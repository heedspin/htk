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
  	current_user = args[:current_user] || (raise ':current_user required')
    params = args[:params] || {}
    deliverable_type = if deliverable_type_id = params[:deliverable_type_id]
      DeliverableTypeConfig.find(deliverable_type_id).ar_type_class
    else
      DeliverableTypeConfig.standard.ar_type_class
    end
  	deliverable = deliverable_type.new
    if Rails.env.test? and params.member?(:id)
      deliverable.id = params[:id]
    end
    deliverable.status_id = params[:status_id] || LifeStatus.active.id
    accessible_attributes = deliverable_type.accessible_attributes.select(&:present?)
    deliverable.update_attributes(params.select { |k,v| accessible_attributes.include?(k.to_s) })
    # id = args[:id]
    # deliverable.id = id if id.present?
  	Deliverable.transaction do
      deliverable.save!
      if current_user.user_group_id
        deliverable.permissions.create!(access_id: DeliverableAccess.read.id, group_id: current_user.user_group_id)
      end
  		# email.message.message_thread.deliverables << deliverable
  		User.email_accounts(email.participants).accessible_to(current_user).each do |recipient|
  			access = if recipient.id == current_user.id
  				DeliverableAccess.owner
  			else
  				DeliverableAccess.edit
  			end
  			deliverable.permissions.create!(user_id: recipient.id, access_id: access.id, group_id: current_user.user_group_id)
  		end
  	end
  	deliverable
  end
end
