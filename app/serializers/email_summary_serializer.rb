class EmailSummarySerializer < ActiveModel::Serializer
	embed :ids, include: true
  attributes :id, :date, :subject
  has_many :parties, key: :parties
  has_many :to_email_accounts, root: :email_accounts, serializer: EmailAccountSerializer, key: :to_email_accounts
  has_many :from_email_accounts, root: :email_accounts, serializer: EmailAccountSerializer, key: :from_email_accounts
  has_many :cc_email_accounts, root: :email_accounts, serializer: EmailAccountSerializer, key: :cc_email_accounts
end
