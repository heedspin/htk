require 'comments_gadget_compiler'

class TestCommentsGadgetController < ApplicationController
	def index
		render layout: false
	end

	helper_method :insert_file
	def insert_file(filename)
		CommentsGadgetCompiler.new(Rails.env).insert_file(filename)
	end
end
