require 'comments_gadget_compiler'

namespace :htk do
  desc "Build HTK Gadgets"
  task :build_gadgets => :environment do
  	output_directory = File.join(source_directory, 'output')
  	['development', 'production'].each do |environment|
  		['manifest', 'spec'].each do |base_filename|
	  		output_file = File.join(output_directory, "#{base_filename}_#{environment}.xml")
		  	File.open(output_file, 'w+') do |out|
		  		input_file = File.join(source_directory, "#{base_filename}.xml.erb")
		  		out << CommentsGadgetCompiler.new(environment).insert_file(input_file)
		  	end
		  	puts "Wrote #{output_file}"
		  end
	  end
  end
end
