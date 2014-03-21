require 'deliverables_gadget_compiler'

# bundle exec rake htk:build_deliverables RAILS_ENV=development
namespace :htk do
  desc "Build HTK Deliverables Gadget"
  # TODO: Integrate: bundle exec rake assets:precompile RAILS_ENV=development
  task :build_deliverables => :environment do
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
				puts `s3cmd put -c config/s3cfg --acl-public #{output_path} s3://lxd-stk/deliverables_gadget/#{base_filename}_#{Rails.env}-v#{compiler.version}.xml`
			end
	  end
	  # Keep from messing up development mode!
		Rake::Task["assets:clean"].invoke
  end
end
