# == Schema Information
#
# Table name: email_threads
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EmailThread < ApplicationModel
	has_many :email_account_threads
end
