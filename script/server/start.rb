require 'rubygems'
require 'ruby-debug'

class Ec2Instance
	def initialize(instance_id)
		@instance_id = instance_id
	end

	def status
		output = `ec2-describe-instances #{@instance_id}`
		output.split("\n")[1].split("\t")[5]
	end

	def start
		output = `ec2-start-instances #{@instance_id}`
	end

	def associate_address(ip_address)
		output = `ec2-associate-address #{ip_address} -i #{@instance_id}`
	end
end

class Start
	def run(instance_id, ip_address)
		server = Ec2Instance.new(instance_id)
		if server.status == 'stopped'
			puts server.start
			sleep 2
		end
		while (status = server.status) != 'running' do
			puts status
			sleep 2
		end
		puts status
		puts server.associate_address(ip_address)
		0
	end
end

exit Start.new.run('i-b14809d1', '54.235.164.67')
