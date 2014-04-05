require 'deliverables_gadget_compiler'

class TestDeliverablesGadgetController < ApplicationController
	def index
		render layout: false
	end

	helper_method :insert_file
	def insert_file(filename)
		DeliverablesGadgetCompiler.new.insert_file(filename)
	end
end
