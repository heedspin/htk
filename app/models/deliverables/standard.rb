# == Schema Information
#
# Table name: deliverables
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  description     :text
#  type            :string(255)
#  data            :text
#  abbreviation    :string(255)
#  completed_by_id :integer
#  status_id       :integer
#

class Deliverables::Standard < Deliverable
  def self.create_from_email(args)
  	email = args[:email] || (raise ':email required')
    current_user = args[:current_user] || email.user || (raise ':current_user required')
    params = args[:params] || {}
    permissions = args[:permissions] || []
    # deliverable_type = if deliverable_type_id = params[:deliverable_type_id]
    #   DeliverableTypeConfig.find(deliverable_type_id).ar_type_class
    # else
    #   DeliverableTypeConfig.standard.ar_type_class
    # end
    # deliverable = deliverable_type.new
    deliverable = new
    if Rails.env.test? and params.member?(:id)
      deliverable.id = params[:id]
    end
    deliverable.status_id = params[:status_id] || LifeStatus.active.id
    accessible_attributes = self.accessible_attributes.select(&:present?)
    deliverable.update_attributes(params.select { |k,v| accessible_attributes.include?(k.to_s) })
    # id = args[:id]
    # deliverable.id = id if id.present?
  	Deliverable.transaction do
      # Create owner user and permission.
      email.from_user.save! if email.from_user.new_record?
      permissions.push deliverable.permissions.create!(access: DeliverableAccess.owner, user_id: email.from_user.id)
      # if email.from_user.user_group_id and (email.from_user.user_group_id == current_user.user_group_id)
      #   # Creator from same group gets edit permissions.
      # end
      deliverable.save!
      if current_user.user_group_id
        permissions.push deliverable.permissions.create!(access: DeliverableAccess.edit, group_id: current_user.user_group_id)
      end
  	end
  	deliverable
  end
end
