require 'net/imap'
require 'plutolib/logger_utils'

class HtkImap < Net::IMAP
  include Plutolib::LoggerUtils
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

  def folder_map
    if @folder_map.nil?
      @folder_map = {}
      self.list('', '*').each do |mbl|
        unless (mbl.attr.include?(:Noselect))
          @folder_map[mbl.name] = mbl
        end
      end
    end
    @folder_map
  end

  def ensure_folder(folder_path_array)
    folder_path = nil
    folder_path_array.each_with_index do |name, index|
      folder_path = folder_path_array[0..index].join('/')
      unless self.folder_map.member? folder_path
        self.create folder_path
      end
    end
    folder_path
  end

  def delete_if_empty(folder_path_array)
    folder_path = folder_path_array.join('/')
    self.examine(folder_path)
    remaining = self.uid_search(["ALL"])
    if remaining.size == 0
      log "removing empty folder #{folder_path}"
      self.delete(folder_path)
    else
      log "still #{remaining.size} emails left in folder #{folder_path}"
    end
  end

end

require 'mail'
require 'htk_imap/raw_email'
require 'htk_imap/gmail_imap'
require 'htk_imap/gmail_email'
require 'htk_imap/mail_utils'
