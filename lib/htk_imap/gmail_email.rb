class HtkImap::GmailEmail < HtkImap::RawEmail
	def self.fetch_since(args, &block)
    offset = args[:offset] || 0
    limit = args[:limit] || 10
		imap = args[:imap]
		since_uid = args[:since_uid]
		# Add one so we do not reload the past email.  IMAP gaurantees always increasing.
		imap.send(:send_command, "UID SEARCH UID #{since_uid+1}:*")
		uids = imap.responses.delete('SEARCH')[-1]
		# uids.shift # the first one is our
		if uids.size > 0
			fetch_uids(imap, uids.reverse[offset..(offset + (limit-1))], args[:current_folder], &block)
		else
			[]
		end
	end

	def self.fetch_all(args, &block)
    offset = args[:offset] || 0
    limit = args[:limit] || 1000
    imap = args[:imap]
    current_folder = args[:current_folder]
    uids = imap.uid_search(["ALL"])
    fetch_uids(imap, uids.reverse[offset..(offset + (limit-1))], args[:current_folder], &block)
	  #   message_ids.reverse[offset..(offset + (limit-1))].each do |uid| 
	  #     e = new(imap: imap, uid: uid, folder: current_folder)
	  #     if e.valid?
	  #     	result.push(block_given? ? yield(e) : e)
		# 	end
		# end
		# result
	end

	def self.fetch_for_thread(args, &block)
		imap = args[:imap]
		thread_id = args[:thread_id]
    uids = imap.uid_search(['X-GM-THRID', thread_id])
    fetch_uids(imap, uids, args[:current_folder])
    # message_ids.map do |uid|
    #   HtkImap::GmailEmail.new(imap: imap, uid: uid, folder: current_folder)
    # end.select(&:valid?)
  end

	def self.fetch_uids(imap, uids, folder, &block)
		if data = imap.uid_fetch(uids, ['RFC822', 'X-GM-MSGID', 'X-GM-THRID'])
			result = []
			data.each do |d| 
				e = new(:data => d, :folder => folder)
				if e.valid?
					result.push(block_given? ? yield(e) : e)
				end
			end
			result
		else
			[]
		end
	end

	def initialize(args={})
		super()
		data = args[:data]
		if data.nil?
			imap = args[:imap] || (raise 'imap required')
			@uid = args[:uid] || (raise 'uid required')
			data = imap.uid_fetch(@uid, ['RFC822', 'X-GM-MSGID', 'X-GM-THRID'])
			data = data[0]
		end
		if data
			@mail = Mail.new(data.attr['RFC822'])
			@uid = data.attr['UID'].try(:to_s)
			@guid = data.attr['X-GM-MSGID'].try(:to_s)
			@thread_id = data.attr['X-GM-THRID'].try(:to_s)
			@folder = args[:folder]
		end
	end

	def valid?
		@mail.present?
	end

end
