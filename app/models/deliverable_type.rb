# == Schema Information
#
# Table name: deliverable_types
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  key         :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class DeliverableType < ApplicationModel
	attr_accessible :name, :description, :key
	validates_uniqueness_of :key
end
