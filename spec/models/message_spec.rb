require 'rails_helper'
require 'support/test_gmails.rb'

RSpec.describe Message, :type => :model do
  context 'import email' do
    it 'creates one message from two emails' do
      emails = []
      TestGmails.by_date(:two_emails_one_message).each do |email, message|
        user = UserFactory.create(email)
        expect(user).to be_truthy
        gs = Htkoogle::GmailSynchronization.create!(user: user)
        gs.handle_message(message)
        expect(email = Email.user(user).web_id(message.id).first).to be_truthy
        emails.push email
      end
      expect(emails.size).to eq(2)
      expect(emails.map(&:message).uniq.size).to eq(1)
    end
  end
end
