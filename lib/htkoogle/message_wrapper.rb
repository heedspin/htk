require 'plutolib/regex_utils'

module Htkoogle
	class MessageWrapper
		attr :data
		def initialize(data)
			@data = data
		end
		%w(id threadId snippet).each do |key|
			class_eval <<-RUBY
			def #{key.underscore}
				self.data['#{key}']
			end
			RUBY
		end
		def headers(name)
			@headers ||= self.data['payload']['headers']
			result = @headers.find { |h| h['name'] == name }
			result && result['value']
		end
		[[:subject, 'Subject'], [:from_address, 'From']].each do |method, gkey|
			class_eval <<-RUBY
			def #{method}
				self.headers('#{gkey}')
			end
			RUBY
		end
		def date
			@date ||= Date.parse(self.headers('Date'))
		end
		def to_addresses
			@to_addresses ||= self.headers('To').split(',').uniq
		end
		def cc_addresses
			@cc_addresses ||= self.headers('Cc').split(',').uniq
		end
		def history_id
			self.data['historyId'].try(:to_i)
		end
		def method_missing(id)
			@data.send(id)
		end
		def to_s
			"#{id} TID:#{thread_id} #{snippet}"
		end
		def build_email(user_id)
			email = Email.new(web_id: id,
				user_id: user_id, 
				thread_id: self.thread_id, 
				date: self.date, 
				from_address: self.from_address, 
				to_addresses: self.to_addresses,
				cc_addresses: self.cc_addresses,
				snippet: self.snippet)
		end
	end
end
