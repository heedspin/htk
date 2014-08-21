# require 'htkoogle/htkoogle' ; Htkoogle::CachedApi.cache(GoogleAuthorization.last, 'admin', 'directory_v1')
# require 'htkoogle/htkoogle' ; Htkoogle::CachedApi.cache(GoogleAuthorization.last, 'gmail')
require 'fileutils'
require 'singleton'
module Htkoogle
	class CachedApi
		include Singleton

		def get(client, interface_name, interface_version=nil)
			client.discovered_api(interface_name, interface_version)
		end

		def self.get(client, interface_name, interface_version=nil)
			instance.get(client, interface_name, interface_version)
		end
		
		def cache(google_authorization, api_name, version=nil)
			google_authorization.with_client! do |client| 
				api = client.discovered_api(api_name, version)
				destination = Rails.root.join('tmp/google_apis')
				FileUtils.mkdir_p destination
				filename = [api_name, version].compact.join('_') + '.json'
				File.open(File.join(destination, filename), 'w+') { |out| out.write(api._dump(0)) }
				true
			end
		end
	end
end