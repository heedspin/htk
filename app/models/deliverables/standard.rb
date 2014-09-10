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
#  user_group_id   :integer
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
    deliverable.user_group_id = current_user.user_group_id
    deliverable.source_email_id = email.id
    accessible_attributes = self.accessible_attributes.select(&:present?)
    deliverable.update_attributes(params.select { |k,v| accessible_attributes.include?(k.to_s) })
    # id = args[:id]
    # deliverable.id = id if id.present?
  	Deliverable.transaction do
      # Create creator user.
      email.from_user.save! if email.from_user.new_record?
      deliverable.creator_id = email.from_user.id
      deliverable.save!
      if current_user.user_group_id
        permissions.push deliverable.permissions.create!(access: DeliverableAccess.edit, user_id: nil)
      end
  	end
  	deliverable
  end
end
