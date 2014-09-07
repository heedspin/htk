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

class Deliverables::Project < Deliverables::Standard
end
