require 'digest/md5'

class HtkImap::RawEmail
	attr_accessor :mail, :thread_id, :uid, :guid, :folder
end
