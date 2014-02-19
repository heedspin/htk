require 'uglifier'
require 'html_press'
require 'action_view/helpers/javascript_helper'

class GadgetCompiler
	include ActionView::Helpers::JavaScriptHelper
	attr_accessor :environment, :config, :source_directory, :name
	def initialize(environment, name)
		self.name = name
		self.source_directory = File.join(Rails.root, 'extensions', name)
  	gadget_config = YAML::load(IO.read(File.join(self.source_directory, name + '_config.yml')))
		self.environment = environment
		self.config = gadget_config[self.environment]
	end

	def version
		self.config['version']
	end

	def insert_file(filename, options=nil)
		options ||= {}
		result = IO.read(File.join(self.source_directory, filename))
		if filename =~ /.*\.erb$/
			result = ERB.new(result).result(binding)
		end
		if filename =~ /.*\.html(\.erb)?$/
			result = HtmlPress.press(result)
		elsif filename =~ /.*\.js(\.erb)?$/ and (self.environment == 'production')
			result = Uglifier.compile(result)
		end
		if options[:javascript_escape]
			result = escape_javascript result
		end
		result.html_safe
  end
end
