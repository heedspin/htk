Dir[Rails.root.join('spec/lib/test_gmails/*.rb')].each {|file| require file }
require 'htkoogle/message_wrapper'

module TestGmails
	def self.by_date(key, options={})
		except = options[:except]
		except = [except] unless except.is_a?(Array)
		all_messages = []
		self.send(key).each do |email, messages|
			messages.each do |m|
				next if except.include?(m['id'])
				# Dup the email or: can't modify frozen String
				all_messages.push [email.dup, Htkoogle::MessageWrapper.new(m)]
			end
		end
		all_messages.sort_by { |email, message| message.date }
	end
end

# require 'htkoogle/htkoogle' ; Htkoogle::ExportThreadBySubject.new("Subject Here", ['tim@126bps.com', 'lindsay@126bps.com']).export
# require 'htkoogle/htkoogle' ; Htkoogle::ExportThreadBySubject.new("same email to two groups", ['tharrison@lxdinc.com', 'lindsay@126bps.com']).export