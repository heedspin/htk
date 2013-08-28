class EmailSerializer < ActiveModel::Serializer
	embed :ids, include: true
  attributes :id, :date, :subject, :html_body
  has_many :parties
end
