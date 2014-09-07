require 'import_single_email'

class UserFactory
	class << self
		def create(args)
			if args.is_a?(String)
				args = { email: args }
			else
				args = args.dup
			end
			email = args[:email] || (raise ':email required')
			args[:status] ||= UserStatus.active 
			unless user_group = args[:user_group]
				domain = email.split('@').last
				args[:user_group] = UserGroup.group_name(domain).first || UserGroup.create!(name: domain)
			end
			user = User.build(args)
			user.save!
			user
		end
	end
end