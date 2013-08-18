class UserSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :email
  has_many :email_accounts
end
