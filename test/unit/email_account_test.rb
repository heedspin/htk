# == Schema Information
#
# Table name: email_accounts
#
#  id                    :integer          not null, primary key
#  status_id             :integer
#  user_id               :integer
#  username              :string(255)
#  authentication_string :string(255)
#  server                :string(255)
#  port                  :integer
#  last_uid              :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'test_helper'

class EmailAccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
