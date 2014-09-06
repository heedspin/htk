# require 'htkoogle/htkoogle' ; Htkoogle::ExportThreadBySubject.new("Subject Here", ['tim@126bps.com', 'lindsay@126bps.com']).export
# require 'htkoogle/htkoogle' ; Htkoogle::ExportThreadBySubject.new("chocolate procurement", ['tim@126bps.com', 'lindsay@126bps.com']).export
require 'pp'
require 'fileutils'
module Htkoogle
	class ExportThreadBySubject
		attr :subject, :email_addresses
		def initialize(subject, email_addresses)
			@subject = subject
			@email_addresses = email_addresses
			@undersubject = @subject.gsub(' ', '_').underscore
		end

		def export(filename=nil)
			filename ||= @undersubject
			result = {}
			self.email_addresses.each do |email|
				result_messages = result[email] = []
				user = User.email(email).first
				user.google_authorization.with_client! do |client|
					api = client.discovered_api('gmail')
					response = client.execute!(api.users.messages.list, userId: 'me', q: "subject:#{self.subject}")
					message_list_data = JSON.parse(response.body)
					messages = message_list_data['messages']
					if messages.nil?
						pp message_list_data
						puts "No results for #{self.subject}"
						return
					end
					thread_id = messages.first['threadId']
					message_ids = messages.select { |m| m['threadId'] == thread_id }.map { |m| m['id'] }
					message_ids.each do |message_id|
						r = client.execute!(api.users.messages.get, :userId => 'me', id: message_id, format: 'full')
						result_messages.push(JSON.parse(r.body))
					end
				end
			end
			destination = Rails.root.join('test/fixtures/test_gmails', "#{filename}.rb")

			File.open(destination, 'w+') do |out| 
				out.write "module TestGmails\n\tdef self.#{@undersubject}\n"
			  PP.pp(result,out)
			  out.write "\tend\nend"
			end
		end
	end
end