class Api::V1::CompaniesController < Api::V1::ApiController
	respond_to :json
	def default_serializer_options
	  {root: 'deliverable'}
	end

	def index
		@companies = Deliverables::Company.accessible_to(current_user)
	end
end