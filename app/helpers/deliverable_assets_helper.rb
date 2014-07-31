require 'uglifier'
require 'html_press'

module DeliverableAssetsHelper
	def gadget_root
		Rails.root.join('extensions', 'deliverables_gadget')
	end

  def gadget_config
  	@gadget_config ||= YAML::load(IO.read(File.join(gadget_root, 'deliverables_gadget_config.yml')))[Rails.env.to_s]
  end

	def version
		gadget_config['version']
	end

	def insert_file(filename, options=nil)
		options ||= {}
		filename = asset_path(filename.to_s)
		if not File.exists?(filename)
			raise "#{filename} does not exist"
		end
		# input_file = (filename[0] == '/') ? filename :  File.join(gadget_root, filename)
		result = IO.read(input_file)
		if filename =~ /.*\.erb$/
			result = ERB.new(result).result(binding)
		end
		if filename =~ /.*\.html(\.erb)?$/
			result = HtmlPress.press(result)
		elsif filename =~ /.*\.js(\.erb)?$/ and Rails.env.production?
			result = Uglifier.compile(result)
		end
		if options[:javascript_escape]
			result = escape_javascript result
		end
		result.html_safe
  end

end