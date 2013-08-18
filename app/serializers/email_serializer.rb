class EmailSerializer < ActiveModel::Serializer
  attributes :id, :date, :subject, :uid
end
