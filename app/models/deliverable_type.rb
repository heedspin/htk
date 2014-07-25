# == Schema Information
#
# Table name: deliverable_types
#
#  id                         :integer          not null, primary key
#  name                       :string(255)
#  description                :text
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  deliverable_type_config_id :integer
#

class DeliverableType < ApplicationModel
	attr_accessible :name, :description, :deliverable_type_config_id
	belongs_to_active_hash :deliverable_type_config

	def self.deliverable_types(types)
		where(deliverable_type_config_id: types.uniq.map { |type| DeliverableTypeConfig.where(ar_type: type).first.try(:id) })
	end

  def has_behavior?(key)
    self.deliverable_type_config.has_behavior?(key)
  end

  def self.deliverable_type_config(config_or_id)
  	id = config_or_id.is_a?(DeliverableTypeConfig) ? config_or_id.id : config_or_id
  	where deliverable_type_config_id: id
  end
end
