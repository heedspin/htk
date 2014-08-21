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
		attr_accessible :user_id, :user

		def reload!
			self.last_history_id = nil
			self.run!
		end

		def run!
			self.last_sync = Time.current
			if self.last_history_id.blank?
				self.full_sync!
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

		def maxSetHistoryId(history_id)
			if self.last_history_id.nil? or (history_id > self.last_history_id)
				self.last_history_id = history_id
			end
		end

		def full_sync!
			self.with_client do |client|
				response = client.execute!(self.gmail_api.users.messages.list, userId: self.user.email)
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
				data = JSON.parse(response.body)
				log 'history result = ' + data.inspect
				if history_records = data['history']
					self.download_messages history_records.map { |r| r['messages'] }.flatten
				end
			end
		end

		def download_messages(message_ids)
			message_ids = message_ids.map { |m| m['id'] }.uniq
			log 'download_messages: ' + message_ids.inspect
			if message_ids.size == 1
	      response = @client.execute!(self.gmail_api.users.messages.get, userId: self.user.email, id: message_ids[0], format: 'full')
				self.handle_message(JSON.parse(response.body))	      
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

		def handle_message(response_data)
			gmsg = Htkoogle::MessageWrapper.new(response_data)
			self.maxSetHistoryId gmsg.history_id
			email = Email.user(self.user_id).web_id(gmsg.id).first
			if email
				# already imported
			else
				email = gmsg.build_email(self.user_id)
				import_single_email(email)
				# RandyPleaseProcessor.new(email).run
			end
			true
		end

	end
end
