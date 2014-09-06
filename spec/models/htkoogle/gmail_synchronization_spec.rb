# == Schema Information
#
# Table name: gmail_synchronizations
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  last_sync       :datetime
#  last_history_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Htkoogle::GmailSynchronization, :type => :model do
	# context 'multiple groups' do
	# 	it 'creates deliverable for current group only' do
	# 	end
	# end
end
