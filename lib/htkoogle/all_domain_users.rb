# require 'htkoogle/htkoogle' ; Htkoogle::AllDomainUsers.run(GoogleAuthorization.last)
module Htkoogle
	class AllDomainUsers
		def self.run(google_authorization)
			google_authorization.with_client! do |client| 
				api = client.discovered_api('admin', 'directory_v1')
				response = client.execute!(api.users.list, domain: google_authorization.user.email_domain)
				puts JSON.parse(response.body).inspect
				true
			end
		end
	end
end