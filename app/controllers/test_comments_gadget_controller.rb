require 'gadget_compiler'

class TestCommentsGadgetController < ApplicationController
	def index
		render layout: false
	end

	helper_method :insert_file
	def insert_file(filename)
		GadgetCompiler.new(Rails.env, 'comments_gadget').insert_file(filename)
	end
end
