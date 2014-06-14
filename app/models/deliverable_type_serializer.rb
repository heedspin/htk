class DeliverableTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :js_controller

  def js_controller
  	object.deliverable_type_config.try(:js_controller)
  end

  def config_id
  	object.deliverable_type_config.try(:id)
  end
end
