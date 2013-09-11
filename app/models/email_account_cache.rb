module EmailAccountCache
	attr_accessor :email_account_cache
	%w(from to cc).each do |key|
		self.class_eval <<-RUBY
			def #{key}_email_accounts
				if @#{key}_email_accounts.nil?
					@#{key}_email_accounts = []
					self.#{key}_addresses.each do |address|
						if self.email_account_cache and self.email_account_cache.member?(address)
							if ea = email_account_cache[address]
								@#{key}_email_accounts.push ea
							end
						elsif ea = EmailAccount.username(address).first
							@#{key}_email_accounts.push ea
						end
					end
				end
				@#{key}_email_accounts
			end
		RUBY
	end
end