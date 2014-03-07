class ThreadFactory
	class << self
		def create_thread(args)
			num_users = args[:users] || 1
			num_messages = args[:messages] || 1
			# num_non_members = args[:non_members] || 0
			subject = args[:subject] || "subject-#{MessageThread.count + 1}"
			member_accounts = []
			(1..num_users).each do |i|
				user = User.new(email: "tu#{i}@domain.com", first_name: "domainu#{i}")
				user.save(validate: false)
				member_accounts.push user.email_accounts.create!(username: user.email)
			end
			message_thread = MessageThread.create!
			(1..num_messages).each do |i|
				message = Message.create!(message_thread: message_thread)
				member_accounts.each do |eac|
					eat = eac.email_account_threads.create! message_thread: message_thread, subject: subject
					eat.emails.create!(message: message)
				end
			end
			message_thread
		end
	end
end