require 'gadget_compiler'

class TestDeliverablesGadgetController < ApplicationController
	def index
		render layout: false
	end

	helper_method :insert_file
	def insert_file(filename)
		GadgetCompiler.new(Rails.env, 'deliverables_gadget').insert_file(filename)
	end
end
