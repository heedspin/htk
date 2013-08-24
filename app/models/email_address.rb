class EmailAddress
	include ActiveModel::Serialization

	def initialize(id, address)
		@id = id
		@address = address
	end

  attr_accessor :id, :address

  def attributes
    {'id' => nil, 'address' => nil}
  end

end