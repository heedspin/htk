# == Schema Information
#
# Table name: messages
#
#  id                  :integer          not null, primary key
#  status_id           :integer          default(2)
#  message_thread_id   :integer
#  envelope_message_id :string(255)
#  source_email_id     :integer
#  created_at          :datetime
#  data                :text
#  user_group_id       :integer
#

require 'rails_helper'
require 'support/test_gmails.rb'

RSpec.describe Message, :type => :model do
  context 'import email' do
    it 'creates one message from two emails in the same group' do
      emails = []
      users = []
      TestGmails.by_date(:two_emails_one_message).each do |email, message|
        users.push user = UserFactory.create(email)
        expect(user).to be_truthy
        gs = Htkoogle::GmailSynchronization.create!(user: user)
        gs.handle_message(message)
        expect(email = Email.user(user).web_id(message.id).first).to be_truthy
        emails.push email
      end
      expect(emails.size).to eq(2)
      expect(emails.map(&:message).uniq.size).to eq(1)
      expect(users.first.user_group_id).to eq(users.last.user_group_id)
    end

    it 'creates two messages from two emails in different groups' do
      emails = []
      users = []
      TestGmails.by_date(:same_email_to_two_groups).each do |email, message|
        users.push user = UserFactory.create(email)
        expect(user).to be_truthy
        gs = Htkoogle::GmailSynchronization.create!(user: user)
        gs.handle_message(message)
        expect(email = Email.user(user).web_id(message.id).first).to be_truthy
        emails.push email
      end
      expect(emails.size).to eq(2)
      expect(emails.map(&:message).uniq.size).to eq(2)
      expect(users.first.user_group_id).not_to eq(users.last.user_group_id)
    end
  end
end
