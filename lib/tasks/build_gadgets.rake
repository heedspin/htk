require 'comments_gadget_compiler'

namespace :htk do
  desc "Build HTK Gadgets"
  task :build_gadgets => :environment do
  	['development', 'production'].each do |environment|
	  	compiler = CommentsGadgetCompiler.new(environment)
	  	output_directory = File.join(compiler.source_directory, 'output')
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
