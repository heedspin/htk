class HtkImap::GmailEmail < HtkImap::Email
	attr_accessor :uid, :guid, :mail

	def self.fetch_range(first_message_id, last_message_id)
		if data = imap.uid_fetch("#{first_message_id}:#{last_message_id}", ['RFC822', 'X-GM-MSGID', 'X-GM-THRID'])
			data.map { |d| new(:data => d) }
		else
			[]
		end
	end

	def initialize(args={})
		data = args[:data]
		if data.nil?
			imap = args[:imap] || (raise 'imap required')
			@uid = args[:uid] || (raise 'uid required')
			data = imap.uid_fetch(@uid, ['RFC822', 'X-GM-MSGID', 'X-GM-THRID'])
			data = data[0]
		end
		if data
			@mail = Mail.new(data.attr['RFC822'])
			@guid = data.attr['X-GM-MSGID'].try(:to_s)
			@email_conversation_id = data.attr['X-GM-THRID'].try(:to_s)
			@folder = args[:folder]
		end
	end

	def valid?
		@mail.present?
	end

end
