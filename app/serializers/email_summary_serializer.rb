class EmailSummarySerializer < ActiveModel::Serializer
	embed :ids, include: true
  attributes :id, :date, :subject
  has_many :parties

  # def party_summaries
  # 	object.parties
  # end
end
