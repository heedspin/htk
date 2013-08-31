class MessageSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :subject, :date, :html_body, :hidden
  has_many :to_email_accounts, root: :email_accounts, serializer: EmailAccountSerializer
  has_many :from_email_accounts, root: :email_accounts, serializer: EmailAccountSerializer
  has_many :cc_email_accounts, root: :email_accounts, serializer: EmailAccountSerializer
end
