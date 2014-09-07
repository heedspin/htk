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

require 'rails_helper'

RSpec.describe Deliverables::Standard, :type => :model do
	context 'permissions' do
		it 'creates creator user and current group permissions' do
			current_user = UserFactory.create(email: 'testuser@htk.com')
			creator_address = 'someone@company1.com'
			bystander1 = 'someone@company2.com'
			bystander2 = 'someone@company3.com'
			expect(Permission.user_or_group(current_user).count).to eq(0)
			expect(User.email(creator_address).count).to eq(0)
			expect(User.email(bystander1).count).to eq(0)
			expect(User.email(bystander2).count).to eq(0)

			# Create email
			email = EmailFactory.create(current_user: current_user,
				from_address: creator_address, 
				to_addresses: [current_user.email, bystander1], 
				cc_addresses: [bystander2])

			# Create deliverable
			deliverable = Deliverables::Standard.create_from_email(current_user: current_user, email: email, params: { title: 'test' })
			expect(deliverable).to be_truthy

			# Bystanders
			expect(User.email(bystander1).count).to eq(0)
			expect(User.email(bystander2).count).to eq(0)			

			# Creator user
			expect(creator = User.inactive.email(creator_address).first).to be_truthy
			expect(creator).to eq(email.from_user)
			expect(creator).to eq(deliverable.creator)
			expect(Permission.user(creator).count).to eq(0)

			# Group permissions
			permissions = Permission.user_group(current_user.user_group_id).all
			expect(permissions.size).to eq(1)
			expect(permission = permissions.first).to be_truthy
			expect(permission.deliverable_id).to eq(deliverable.id)
			expect(permission.access.edit?).to be_truthy
		end
	end
end
