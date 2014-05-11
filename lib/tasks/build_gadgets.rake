require 'deliverables_gadget_compiler'

# bundle exec rake htk:build_deliverables RAILS_ENV=development
namespace :htk do
	def htk_command(command)
		puts command
		puts `#{command}`
	end

  desc "Build HTK Deliverables Gadget"
  # TODO: Integrate: bundle exec rake assets:precompile RAILS_ENV=development
  task :build_deliverables => :environment do
  	Htk::Application.config.action_controller.asset_host = 'stk.lxdinc.com'
  	compiler = DeliverablesGadgetCompiler.new
  	output_directory = Rails.root.join('public', 'deliverables_gadget')
  	FileUtils.mkdir_p output_directory
  	Rake::Task["assets:precompile"].reenable
		Rake::Task["assets:precompile"].invoke
		['manifest', 'spec'].each do |base_filename|
			output_file = "#{base_filename}_#{Rails.env}.xml"
  		output_path = File.join(output_directory, output_file)
	  	File.open(output_path, 'w+') do |out|
	  		out << compiler.insert_file("#{base_filename}.xml.erb")
	  	end
	  	puts "Wrote #{output_file}"
	  	if base_filename == 'spec'
	  		htk_command  "s3cmd put -c config/s3cfg --acl-public #{output_path} s3://stk-west-assets/deliverables_gadget/#{base_filename}_#{Rails.env}-v#{compiler.version}.xml"
			end
	  end
		# htk_command "cd public/assets ; s3cmd sync -c ../../config/s3cfg --acl-public ./ s3://stk-west-assets/assets/ ; cd ../.."
	  # Keep from messing up development mode!
		Rake::Task["assets:clean"].invoke
  end
end
