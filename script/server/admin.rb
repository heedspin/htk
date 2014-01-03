require 'rubygems'
require 'yaml'

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

	def stop
		output = `ec2-stop-instances #{@instance_id}`
	end

	def associate_address(ip_address)
		output = `ec2-associate-address #{ip_address} -i #{@instance_id}`
	end
end

class Blues
	def initialize(server_name)
    yaml_config = YAML::load(IO.read(File.join(File.dirname(__FILE__), 'server.yml')))
    @config = yaml_config[server_name] || (raise "No server config for #{server_name}")
		@instance_id = @config['instance_id']
		@ip_address = @config['ip_address']
	end

	def start
		server = Ec2Instance.new(@instance_id)
		if server.status == 'stopped'
			puts server.start
			sleep 2
		end
		while (status = server.status) != 'running' do
			puts status
			sleep 2
		end
		puts status
		puts server.associate_address(@ip_address)
		0
	end

	def stop
		server = Ec2Instance.new(@instance_id)
		if server.status == 'running'
			puts server.stop
			sleep 2
		end
		while (status = server.status) != 'stopped' do
			puts status
			sleep 2
		end
		puts status
		0
	end
end

# require 'trollop'
# options = Trollop::options do
#   opt :start_date, "Start date", :type => :date
#   opt :end_date, "End date", :type => :date
# end
# Trollop::die :customer_numbers, "required" unless options[:customer_numbers].present?

exit Blues.new(ARGV[0]).send(ARGV[1])
