require 'uglifier'
require 'html_press'
require 'action_view/helpers/javascript_helper'

class CommentsGadgetCompiler
	include ActionView::Helpers::JavaScriptHelper
	attr_accessor :environment, :config, :source_directory
	def initialize(environment)
  	self.source_directory = File.join(Rails.root, 'extensions/comments_gadget')
  	gadget_config = YAML::load(IO.read(File.join(self.source_directory, 'comments_gadget_config.yml')))
		self.environment = environment
		self.config = gadget_config[self.environment]
	end

	def insert_file(filename, options=nil)
		options ||= {}
		result = IO.read(File.join(self.source_directory, filename))
		if =~ /.*\.erb$/
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
