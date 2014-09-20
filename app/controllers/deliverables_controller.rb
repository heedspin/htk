class DeliverablesController < ApplicationController
	def index
	end

	def show
		@deliverable = Deliverable.accessible_to(current_user).find(params[:id])
		@message_threads = @deliverable.target_relations.includes(message_thread: :messages).all.map(&:message_thread)
	end

	def dashboard
	end
end