require 'rails_helper'
require 'support/test_gmails.rb'

RSpec.describe DeliverableRelation, :type => :model do
  context 'deliverable trees' do

		def get_trees(*deliverable_ids)
			relation = DeliverableRelation.parent_relation.deliverables(deliverable_ids)
			relations = DeliverableRelation.get_trees(relation)
			deliverables = relations.map { |r| [r.source_deliverable_id, r.target_deliverable_id] }.flatten.uniq.compact.sort
			[deliverables, relations]
		end

		before(:each) do
			@current_user = UserFactory.create('user@domain.com')
			DeliverableTypeConfig.enable!(@current_user.user_group_id)
		end

		it "finds all relations" do
			created = Set.new
			#        1000           1001               1002
			#    1003   1004      1005           1006  1007   1008
			# 1009 1010 1011    1012 1013                   1014  1015
			#                                            1016       1017
			#                                        1018    1019 
			#                                 1020 1021 1022
			[	[nil, 1000], [nil, 1001], [nil, 1002],
			  [1000, 1003], [1000, 1004], 
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
			].each do |source, target|
				[source, target].each do |did|
					unless created.member?(did)
						DeliverableFactory.create(current_user: @current_user, params: { id: did })
						created.add did
					end
				end
				DeliverableRelation.create!(source_deliverable_id: source, 
					target_deliverable_id: target, 
					relation_type_id: DeliverableRelationType.parent.id,
					status_id: LifeStatus.active.id)
			end
			d = Deliverable.find(1000)
			expect(d.source_relations.size).to eq(2)
			expect(d.source_relations.map(&:target_deliverable_id).sort).to eq([1003, 1004])

			deliverable_ids, relations = get_trees(1000)
			expect(deliverable_ids).to eq([1000, 1003, 1004, 1009, 1010, 1011])

			deliverable_ids, relations = get_trees(1004)
			expect(deliverable_ids).to eq([1000, 1003, 1004, 1009, 1010, 1011])

			deliverable_ids, relations = get_trees(1001)
			expect(deliverable_ids).to eq([1001, 1005, 1012, 1013])
			expect(relations.size).to eq(4)

			deliverable_ids, relations = get_trees(1001, 1005, 1012, 1013)
			expect(deliverable_ids).to eq([1001, 1005, 1012, 1013])
			expect(relations.size).to eq(4)

			deliverable_ids, relations = get_trees(1007)
			expect(deliverable_ids).to eq([1002, 1006, 1007, 1008, 1014, 1015, 1016, 1017, 1018, 1019, 1020, 1021, 1022])

			deliverable_ids, relations = get_trees(1000, 1001)
			expect(deliverable_ids).to eq([1000, 1003, 1004, 1009, 1010, 1011, 1001, 1005, 1012, 1013].sort)

			deliverable_ids, relations = get_trees(1001, 1004)
			expect(deliverable_ids).to eq([1000, 1003, 1004, 1009, 1010, 1011, 1001, 1005, 1012, 1013].sort)
		end
	end
end
