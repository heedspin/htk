require 'plutolib/logger_utils'

module MonkeyPatchGmailImap
	def self.patch(imap)
		# From https://gist.github.com/kellyredding/2712611
		# patch only this instance of Net::IMAP
		class << imap.instance_variable_get("@parser")
		  # copied from the stdlib net/smtp.rb
		  # Added (n) for ruby 2.
		  def msg_att(n)
		    match(T_LPAR)
		    attr = {}
		    while true
		      token = lookahead
		      case token.symbol
		      when T_RPAR
		        shift_token
		        break
		      when T_SPACE
		        shift_token
		        token = lookahead
		      end
		      case token.value
		      when /\A(?:ENVELOPE)\z/ni
		        name, val = envelope_data
		      when /\A(?:FLAGS)\z/ni
		        name, val = flags_data
		      when /\A(?:INTERNALDATE)\z/ni
		        name, val = internaldate_data
		      when /\A(?:RFC822(?:\.HEADER|\.TEXT)?)\z/ni
		        name, val = rfc822_text
		      when /\A(?:RFC822\.SIZE)\z/ni
		        name, val = rfc822_size
		      when /\A(?:BODY(?:STRUCTURE)?)\z/ni
		        name, val = body_data
		      when /\A(?:UID)\z/ni
		        name, val = uid_data
		 
		      # adding in Gmail extended attributes
		      when /\A(?:X-GM-LABELS)\z/ni
		        name, val = flags_data
		      when /\A(?:X-GM-MSGID)\z/ni
		        name, val = uid_data
		      when /\A(?:X-GM-THRID)\z/ni
		        name, val = uid_data
		      else
		        parse_error("unknown attribute `%s'", token.value, n)
		      end
		      attr[name] = val
		    end
		    return attr
		  end
		 
		end
	end
end

class HtkImap::GmailImap
	include Plutolib::LoggerUtils
  def self.imap_connect(email_account, &block)
    Net::IMAP.debug = true
    imap = HtkImap.new(email_account.server, email_account.port, true)
    MonkeyPatchGmailImap.patch(imap)
    imap.login(email_account.username, email_account.authentication_string)
    if block_given?
	    begin
	    	yield(imap)
	    rescue => e
	    	log_error "Unhandled imap exception", e
	    ensure
	    	unless imap.disconnected?
					imap.logout()
					imap.disconnect()
				end
	    end
	  else
	  	imap
	  end
  end
end
