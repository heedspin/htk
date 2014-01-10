require 'comments_gadget_compiler'

namespace :htk do
  desc "Build HTK Gadgets"
  task :build_gadgets => :environment do
  	['development', 'production'].each do |environment|
	  	source_directory = File.join(Rails.root, 'extensions/comments_gadget')
	  	output_directory = File.join(source_directory, 'output')
	  	compiler = CommentsGadgetCompiler.new(environment, source_directory)
  		['manifest', 'spec'].each do |base_filename|
  			output_file = "#{base_filename}_#{environment}.xml"
	  		output_path = File.join(output_directory, output_file)
		  	File.open(output_path, 'w+') do |out|
		  		out << compiler.insert_file("#{base_filename}.xml.erb")
		  	end
		  	puts "Wrote #{output_file}"
		  	if base_filename == 'spec'
					puts `s3cmd put -c config/s3cfg --acl-public #{output_path} s3://lxd-stk/comments_gadget/#{base_filename}_#{environment}-v#{compiler.version}.xml`
				end
		  end
	  end
  end
end
