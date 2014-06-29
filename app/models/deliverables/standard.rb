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
end
