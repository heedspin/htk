# == Schema Information
#
# Table name: message_threads
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status_id  :integer          default(2)
#

require 'rails_helper'
require 'support/test_gmails.rb'

RSpec.describe MessageThread, :type => :model do
  context 'deliverables for thread' do
    before(:each) do
      @user1 = UserFactory.create('user1@domain.com')
      @user2 = UserFactory.create('user2@domain.com')
      DeliverableTypeConfig.enable!(@user1.user_group_id)
    end

    it 'returns same deliverable for thread' do
      email1_user1 = EmailFactory.create(user: @user1, subject: 'subject', to_addresses: [@user2.email])
     	expect(email1_user1.message.message_thread.deliverables.count).to eq(0)
  		deliverable = DeliverableFactory.create(email: email1_user1, current_user: @user1, relate: true)
     	expect(email1_user1.message.message_thread.deliverables.count).to eq(1)
      email1_user2 = EmailFactory.create(user: @user2, email: email1_user1)
     	expect(email1_user2.message.message_thread.deliverables.count).to eq(1)
      deliverables = email1_user2.message.message_thread.deliverables.not_deleted
     	expect(deliverables.first).to eq(deliverable)
      email2_user2 = EmailFactory.create(user: @user2, thread: email1_user1)
      deliverables = email2_user2.message.message_thread.deliverables.not_deleted
      expect(deliverables.first).to eq(deliverable)
    end
  end
end
