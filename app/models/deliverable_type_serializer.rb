class DeliverableTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :js_controller, :deliverable_type_id

  def js_controller
  	object.deliverable_type_config.try(:js_controller)
  end

  def deliverable_type_id
  	object.deliverable_type_config.try(:id)
  end
end
