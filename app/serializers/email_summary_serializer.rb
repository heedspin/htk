class EmailSummarySerializer < ActiveModel::Serializer
	embed :ids, include: true
  attributes :id, :date, :subject
  has_many :parties
  # has_many :to_email_accounts, root: :email_accounts, serializer: EmailAccountSerializer
  # has_many :from_email_accounts, root: :email_accounts, serializer: EmailAccountSerializer
  # has_many :cc_email_accounts, root: :email_accounts, serializer: EmailAccountSerializer
end
