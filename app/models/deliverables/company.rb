# == Schema Information
#
# Table name: deliverables
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  description     :text
#  completed_by_id :integer
#  type            :string(255)
#  data            :text
#  abbreviation    :string(255)
#  status_id       :integer
#  creator_id      :integer
#

class Deliverables::Company < Deliverable
  def self.create_from_email(args)
  	email = args[:email] || (raise ':email required')
  	creator = args[:creator] || (raise ':creator required')
    params = args[:params] || {}
    deliverable_type = if deliverable_type_id = params[:deliverable_type_id]
      DeliverableTypeConfig.find(deliverable_type_id).ar_type_class
    else
      DeliverableTypeConfig.standard.ar_type_class
    end
  	deliverable = deliverable_type.new
    deliverable.status_id = params[:status_id] || LifeStatus.active.id
    accessible_attributes = deliverable_type.accessible_attributes.select(&:present?)
    Deliverable.transaction do
      deliverable.update_attributes!(params.select { |k,v| accessible_attributes.include?(k.to_s) })
      if creator.user_group_id
        permission = deliverable.permissions.build(access_id: DeliverableAccess.edit.id)
        permission.group_id = creator.user_group_id
        permission.save!
      end
    end
    # id = args[:id]
    # deliverable.id = id if id.present?
  	# Deliverable.transaction do
  	# 	deliverable.save!
  	# 	deliverable.permissions.create!(group_id: creator.company_group_id, 
  	# 		access_id: DeliverableAccess.edit.id)
  	# 	end
  	# end
  	deliverable
  end

  def self.ensure_editable_by!(deliverable_ids, user)
    # TODO: Add group permissions to companies and test against.
    deliverable_ids
  end

  def ensure_editable_by!(user)
    # TODO: Add group permissions to companies and test against.
    self
  end

end
