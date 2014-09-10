# == Schema Information
#
# Table name: gmail_synchronizations
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  last_sync       :datetime
#  last_history_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'htkoogle/cached_api'
require 'htkoogle/message_wrapper'
require 'plutolib/logger_utils'
require 'randy_please_processor'
require 'import_single_email'

# Htkoogle::GmailSynchronization.first.run!
module Htkoogle
	class GmailSynchronization < ApplicationModel
		include Plutolib::LoggerUtils
		include ImportSingleEmail
		belongs_to :user
		attr_accessible :user_id, :user, :last_history_id

		# Htkoogle::GmailSynchronization::Runner.run_all
		class Runner
			def self.run_all
				Runner.new.delay.run_all
			end
			def run_all
				Htkoogle::GmailSynchronization.run_all				
			end
		end

		def self.run_all
			User.active.each do |user|
				begin
					gsync = GmailSynchronization.user(user).first || GmailSynchronization.create!(user: user)
					gsync.run!
				rescue Exception => e
					log_error "Unhandled exception while synchronization gmail", e
					Airbrake.notify_or_ignore(e, 
						error_class: 'GmailSynchronization',
					  parameters: { user_email: user.email })
				end
			end
		end

		def self.user(user)
			user_id = user.is_a?(User) ? user.id : user
			where user_id: user_id
		end

		def reload!
			self.last_history_id = nil
			self.run!
		end

		def run!
			self.last_sync = Time.current
			if self.last_history_id.blank?
				self.initial_sync!
			else
				self.partial_sync!
			end
			self.save!
		end

		def google_authorization
			GoogleAuthorization.user(self.user_id).first
		end

		def with_client(&block)
			self.google_authorization.with_client! do |client|
				@client = client	
				yield(client)
			end
		end

		def gmail_api
			if @client.nil?
				raise "gmail_api called with nil client"
			end
			@gmail_api ||= Htkoogle::CachedApi.get(@client, 'gmail')
		end

		def set_max_history_id(history_id)
			if history_id 
				history_id = history_id.to_i
				if self.last_history_id.nil? or (history_id > self.last_history_id)
					self.last_history_id = history_id
				end
			end
		end

		def initial_sync!
			self.with_client do |client|
				response = client.execute!(self.gmail_api.users.messages.list, userId: self.user.email, maxResults: 50)
				all_messages = JSON.parse(response.body)['messages']
				self.download_messages(all_messages)
				true
			end
		end

		def partial_sync!
			self.with_client do |client|
				response = client.execute!(self.gmail_api.users.history.list, 
					userId: self.user.email, 
					startHistoryId: self.last_history_id, 
					maxResults: 100)
				if response.status == 404
					log_error 'history id too old.  running initial sync'
					self.initial_sync!
				else
					data = JSON.parse(response.body)
					log "history result.  status = #{response.status} data:", data.inspect
					if history_records = data['history']
						self.download_messages history_records.map { |r| r['messages'] }.flatten
					end
					self.set_max_history_id data['historyId']
				end
			end
		end

		def download_messages(message_ids)
			message_ids = message_ids.map { |m| m['id'] }.uniq
			log 'download_messages: ' + message_ids.inspect
			if message_ids.size == 1
				message_id = message_ids[0]
				begin
		      response = @client.execute!(self.gmail_api.users.messages.get, userId: self.user.email, id: message_id, format: 'full')
					self.handle_message(JSON.parse(response.body))	      
				rescue Google::APIClient::ClientError => e
					if e.result.status == 404
						log_error "download_messages 404 for #{self.user.email} message id #{message_id}"
						nil
					else
						log_error "download_messages unhandled exception for #{self.user.email} status #{e.result.status}"
						raise e
					end
				end
			else
				message_ids.each_slice(20) do |batch_ids|
					batch = Google::APIClient::BatchRequest.new { |r| self.handle_message(JSON.parse(r.body)) }
	      	batch_ids.each do |message_id|
			      batch.add(:api_method => self.gmail_api.users.messages.get, 
			      	parameters: {userId: self.user.email, id: message_id, format: 'full'})
			    end
		      @client.execute!(batch)
		    end
			end
		end

		def handle_message(message)
			message = message.is_a?(Htkoogle::MessageWrapper) ? message : Htkoogle::MessageWrapper.new(message)
			self.set_max_history_id message.history_id				
			email = Email.user(self.user_id).web_id(message.id).first if message.id
			if message.importable?
				if email
					# Update email
					msg = "gsync update #{email}"
					email.message_wrapper = message
					if email.changed?
						log msg + " to #{email}"
						email.save!
					else
						log "gsync no change #{email}"
					end
				else
					# Create email
					email = Email.new(message_wrapper: message, user_id: self.user_id)
					log "gsync import #{email}"
					import_single_email(email)
					RandyPleaseProcessor.new(email).run
				end
			elsif email
				# Delete email
				log "gsync delete #{email}"
				email.destroy
			elsif !message.valid?
				log_error "gsync invalid: " + message.data.inspect
			else
				log "gsync ignoring draft #{message.id}"
			end
			true
		end

		def resync_thread(email_account_thread)
			self.with_client do |client|
				begin
		      response = client.execute!(self.gmail_api.users.threads.get, userId: self.user.email, id: email_account_thread.thread_id)
		      all_messages = JSON.parse(response.body)['messages']
		      all_web_ids = all_messages.map { |m| m['id'] }
		      deleted_messages = email_account_thread.emails.all.select { |e| !all_web_ids.include?(e.web_id) }
		      deleted_messages.each(&:destroy)
		      self.download_messages(all_messages)
		    rescue Google::APIClient::ClientError => e
					if e.result.status == 404
						# Thread deleted.
						email_account_thread.destroy
					else
						log_error "resync_email unhandled exception for email_account_thread #{email_account_thread.id} status #{e.result.status}"
						raise e
					end
				end
	    end
		end

		def get_email(email)
			self.with_client do |client|
				begin
		      response = client.execute!(self.gmail_api.users.messages.get, userId: self.user.email, id: email.web_id, format: 'full')
		      Htkoogle::MessageWrapper.new(JSON.parse(response.body))
				rescue Google::APIClient::ClientError => e
					if e.result.status == 404
						nil
					else
						log_error "get_email unhandled exception for email #{email.id} status #{e.result.status}"
						raise e
					end
				end
	    end
		end

		def resync_email(email)
			self.with_client do |client|
				begin
		      response = client.execute!(self.gmail_api.users.messages.get, userId: self.user.email, id: email.web_id, format: 'full')
		      email.message_wrapper = Htkoogle::MessageWrapper.new(JSON.parse(response.body))				
		      if email.changed?
		      	:changed
		      else
		      	:no_change
		      end
				rescue Google::APIClient::ClientError => e
					if e.result.status == 404
						:deleted
					else
						log_error "resync_email unhandled exception for email #{email.id} status #{e.result.status}"
						raise e
					end
				end
	    end
		end

	end
end
