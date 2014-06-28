# == Schema Information
#
# Table name: deliverable_relations
#
#  id                    :integer          not null, primary key
#  status_id             :integer
#  integer               :integer
#  source_deliverable_id :integer
#  target_deliverable_id :integer
#  relation_type_id      :integer
#  message_thread_id     :integer
#  previous_sibling_id   :integer
#  message_id            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'test_helper'

# bundle exec rake test TEST=test/unit/deliverable_relation_test.rb
class DeliverableRelationTest < ActiveSupport::TestCase
	test "should find all relations" do
		current_user = users(:user1)
		created = Set.new
		#        1000           1001               1002
		#    1003   1004      1005           1006  1007   1008
		# 1009 1010 1011    1012 1013                   1014  1015
		#                                            1016       1017
		#                                        1018    1019 
		#                                 1020 1021 1022
		[	[1000, 1003], [1000, 1004], 
			[1003, 1009], [1003, 1010],
			[1004, 1011],
			[1001, 1005],
			[1005, 1012], [1005, 1013],
			[1002, 1006], [1002, 1007], [1002, 1008],
			[1008, 1014], [1008, 1015],
			[1014, 1016],
			[1015, 1017],
			[1016, 1018], [1016, 1019],
			[1018, 1020], [1018, 1021], [1018, 1022]
		].each do |target, source|
			[target, source].each do |did|
				unless created.member?(did)
					DeliverableFactory.create(id: did, current_user: current_user)
					created.add did
				end
			end
			DeliverableRelation.create!(source_deliverable_id: source, target_deliverable_id: target, relation_type_id: DeliverableRelationType.parent.id)
		end
		assert d = Deliverable.find(1000)
		assert_equal 2, d.children.size
		assert_equal [1003, 1004], d.children.map(&:id).sort

		tree, relations = DeliverableRelation.get_trees(1000)
		assert_equal [1000, 1003, 1004, 1009, 1010, 1011], tree.map(&:id).sort

		tree, relations = DeliverableRelation.get_trees(1004)
		assert_equal [1000, 1003, 1004, 1009, 1010, 1011], tree.map(&:id).sort

		tree, relations = DeliverableRelation.get_trees(1001)
		assert_equal [1001, 1005, 1012, 1013], tree.map(&:id).sort
		assert_equal 3, relations.size

		tree, relations = DeliverableRelation.get_trees(1001, 1005, 1012, 1013)
		assert_equal [1001, 1005, 1012, 1013], tree.map(&:id).sort
		assert_equal 3, relations.size

		tree, relations = DeliverableRelation.get_trees(1007)
		assert_equal [1002, 1006, 1007, 1008, 1014, 1015, 1016, 1017, 1018, 1019, 1020, 1021, 1022], tree.map(&:id).sort

		tree, relations = DeliverableRelation.get_trees([1000, 1001])
		assert_equal [1000, 1003, 1004, 1009, 1010, 1011, 1001, 1005, 1012, 1013].sort, tree.map(&:id).sort

		tree, relations = DeliverableRelation.get_trees(1001, 1004)
		assert_equal [1000, 1003, 1004, 1009, 1010, 1011, 1001, 1005, 1012, 1013].sort, tree.map(&:id).sort
	end
end
