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
		def valid?
			self.date.present?
		end
		def importable?
			self.valid? and !self.labelIds.include?('DRAFT')
		end
		def headers(name)
			@headers ||= self.data.try('[]', 'payload').try('[]', 'headers') || []
			result = @headers.find { |h| h['name'] == name }
			result && result['value']
		end
		[[:subject, 'Subject'], [:from_address, 'From'], [:header_message_id, 'Message-ID']].each do |method, gkey|
			class_eval <<-RUBY
			def #{method}
				self.headers('#{gkey}')
			end
			RUBY
		end
		def date
			@date ||= (d = self.headers('Date')) && DateTime.parse(d)
		end
		def to_addresses
			@to_addresses ||= self.headers('To').try(:split, ',').try(:uniq)
		end
		def cc_addresses
			@cc_addresses ||= self.headers('Cc').try(:split, ',').try(:uniq)
		end
		def history_id
			self.data['historyId'].try(:to_i)
		end
		def method_missing(id, *args)
			id = id.to_s
			if @data.member?(id)
				@data[id]
			else
				@data.send(id, *args)
			end
		end
		def to_s
			"#{id} TID:#{thread_id} #{snippet}"
		end
	end
end
