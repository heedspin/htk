require 'net/imap'

module HtkImap
	class ::Net::IMAP::Address
		def to_s
			"#{self.name} <#{self.mailbox}@#{self.host}> #{self.route}"
		end
	end

	class ::Net::IMAP
    def send_data(data)
      case data
      when nil
        put_string("NIL")
      when String
      	# Monkey patch to allow for range searching.  Otherwise, IMAP puts quotes around the xyz:* string and GMail barfs.
      	if data =~ /\d+:[\d\*]+/
	        send_number_data(data)
	      else
	        send_string_data(data)
	      end
      when Integer
        send_number_data(data)
      when Array
        send_list_data(data)
      when Time
        send_time_data(data)
      when Symbol
        send_symbol_data(data)
      else
        data.send_data(self)
      end
    end
  end
end

require 'mail'
require 'htk_imap/raw_email'
require 'htk_imap/gmail_imap'
require 'htk_imap/gmail_email'
require 'htk_imap/mail_utils'
