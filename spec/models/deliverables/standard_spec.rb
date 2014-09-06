require 'rails_helper'

RSpec.describe Deliverables::Standard, :type => :model do
	context 'permissions' do
		it 'creates owner and current group permissions' do
			user = UserFactory.create(email: 'testuser@htk.com')
			expect(Permission.user(user).count).to eq(0)
			expect(Permission.user_group(user.user_group_id).count).to eq(0)
			email = EmailFactory.create(current_user: user,
				from_address: 'someone@company1.com', 
				to_addresses: [user.email, 'someone@company2.com'], 
				cc_addresses: ['someone@company3.com'])
			expect deliverable = Deliverables::Standard.create_from_email(current_user: user, email: email, params: { title: 'test' })

			# owner permissions
			expect owner = email.from_user
			permissions = Permission.user(owner).all
			expect(permissions.size).to eq(1)
			permission = permissions.first
			expect(permission.deliverable_id).to eq(deliverable.id)
			expect(permission.access.owner?).to be_truthy

			# group permissions
			permissions = Permission.user_group(user.user_group_id).all
			expect(permissions.size).to eq(1)
			expect permission = permissions.first
			expect(permission.deliverable_id).to eq(deliverable.id)
			expect(permission.access.edit?).to be_truthy
		end
	end
end
