require 'rails_helper'
require 'randy_please_processor'
require 'import_single_email'

RSpec.describe RandyPleaseProcessor, :type => :model do
	context 'regular expressions' do
		it 'recognizes the hot phrases' do
			john_doe = UserFactory.create(name: 'John Doe', email: 'john@doe.com')
			some_user = UserFactory.create(name: 'Some User', email: 'doesnot@matter.com')
			[ 
				{ 
					text:	'John, would you please send me your chocolate? Lorem ipsum dolor sit amet, consectetur adipiscing elit',
					first_names_to_users: { 
						'joe' =>  john_doe,
						'john' => john_doe
					},
					expect_name: 'John Doe',
					expect_pleasm: 'would you',
					expect_task: 'please send me your chocolate'
				},

				{
					text: 'Some, could you do the thing',
					first_names_to_users: {
						'some' => some_user
					},
					expect_name: 'Some User',
					expect_pleasm: 'could you',
					expect_task: 'do the thing'
				},

				{
					text: "Some, \n\ncan you please\n\n do the\n\n thing",
					first_names_to_users: {
						'some' => some_user
					},
					expect_name: 'Some User',
					expect_pleasm: 'can you',
					expect_task: "please\n\n do the\n\n thing"
				},

				{
					text: "Hi Joe,\n\nPlease find attached specs for mating connector recommendation. Thanks a lot!\n\nBest regards,",
					first_names_to_users: { 'joe' =>  john_doe }
				},

				{ # Verify no first names still works.
					text: 'Hello Jean, Tim, Could you advice? ',
					first_names_to_users: {}
				},

				{ # Verify no matches works.
					text: 'Robot, could you advice?',
					first_names_to_users: { 'joe' => john_doe }
				}
			].each do |test_config|
				results = RandyPleaseProcessor::Pleasm.parse(test_config[:first_names_to_users], test_config[:text])
				if test_config[:expect_pleasm]
					expect(results.size).to eq(1), "for #{test_config[:text]}"
					expect(pleasm = results[0]).to be_truthy
					expect(pleasm.assignee.name).to eq(test_config[:expect_name])
					expect(pleasm.pleasm).to eq(test_config[:expect_pleasm])
					expect(pleasm.task).to eq(test_config[:expect_task])
				else
					expect(results.size).to eq(0), "for #{test_config[:text]}"
				end
			end
		end
	end

	# rspec spec/models/randy_please_processor_spec.rb -e 'users and permissions'
	context 'users and permissions' do
		it 'creates a inactive user for non group significants' do
			current_user = UserFactory.create(email: 'testuser1@htk.com', first_name: 'Current', last_name: 'User')
			assignee_user = UserFactory.create(email: 'testuser2@htk.com', first_name: 'Assignee', last_name: 'User')
			creator_address = 'Creator User <creatoruser@company1.com>'
			innocent_bystander_address = 'someone@company2.com'
			email = EmailFactory.create(current_user: current_user, 
				from_address: creator_address, 
				to_addresses: [current_user.name_and_email, innocent_bystander_address, assignee_user.name_and_email],
				snippet: 'Assignee, would you please do the thing')
			expect(DeliverableRelation.message(email.message).count).to eq(0)
			expect(User.email(creator_address).count).to eq(0)
			expect(User.email(innocent_bystander_address).count).to eq(0)
			RandyPleaseProcessor.new(email).run
			expect(DeliverableRelation.message(email.message).count).to eq(1)
			owners = User.inactive.user_group(nil).email(creator_address)
			expect(owners.count).to eq(1)
			owner = owners.first
			expect(User.email(innocent_bystander_address).count).to eq(0)
		end
	end

	context 'tasks' do
		it 'opens and closes a task' do
	    emails = []
	    task_email = nil
	    done_email = nil
			expect(User.email('tharrison@lxdinc.com').count).to eq(0)
	    gmails = TestGmails.by_date(:chocolate_procurement)
	    # Create all users.
	    gmails.each { |email_address, m| User.find_by_email(email_address) || UserFactory.create(email: email_address) }
    	# Process emails.
	    gmails.each do |email_address, message|
	      user = User.find_by_email(email_address)
	      expect(user.user_group_id).to be_truthy, "#{email_address} has no group"
	      gs = Htkoogle::GmailSynchronization.create!(user: user)
	      gs.handle_message(message)
	      emails.push email = Email.user(user).web_id(message.id).first
	      expect(email).to be_truthy
	      if message.id == '148002f2fd0cf062'
	      	task_email = email
	      elsif message.id == '14804ad611214514'
	      	done_email = email
	      end
	    end
	    message_threads = emails.map(&:message_thread).uniq
	    expect(message_threads.size).to eq(1)

	    # Deliverable
	  	relations = DeliverableRelation.messages(emails.map(&:message_id)).all
	  	expect(relations.size).to eq(1)
	  	relation = relations.first
	  	expect(relation.message_id).to eq(task_email.message_id)

	  	# Creator
	  	expect(creator = relation.target_deliverable.creator).to be_truthy
	  	expect(creator).to eq(task_email.from_user)
			expect(creator.email).to eq('tim@126bps.com')

	  	# Assignment
	  	assigned = relation.target_deliverable.permissions.responsible(true).all
	  	expect(assigned.size).to eq(1)
	  	expect(assigned.first.user.email).to eq(task_email.to_emails.first)
			expect(User.email('tharrison@lxdinc.com').count).to eq(1)

			# Completion
			expect(relation.target_deliverable.complete?).to be
			expect(relation.target_deliverable.completed_by_id).to eq(done_email.from_user.id)
		end

		it 'does not close a task' do
	    emails = []
	    task_email = nil
	    gmails = TestGmails.by_date(:chocolate_procurement, except: ['14804ad5ff61cc88', '14804ad611214514'])
	    # Create all users.
	    gmails.each { |email_address, m| User.find_by_email(email_address) || UserFactory.create(email: email_address) }
    	# Process emails.
	    gmails.each do |email_address, message|
	      user = User.find_by_email(email_address)
	      Htkoogle::GmailSynchronization.create!(user: user).handle_message(message)
	      emails.push email = Email.user(user).web_id(message.id).first
	      expect(email).to be_truthy
      	task_email = email if message.id == '148002f2fd0cf062'
	    end

	    # Deliverable
	  	relations = DeliverableRelation.messages(emails.map(&:message_id)).all
	  	expect(relations.size).to eq(1)
	  	relation = relations.first
	  	expect(relation.message_id).to eq(task_email.message_id)

	  	# Assignment
	  	assigned = relation.target_deliverable.permissions.responsible(true).all
	  	expect(assigned.size).to eq(1)
	  	expect(assigned.first.user.email).to eq(task_email.to_emails.first)

			# Completion
			expect(relation.target_deliverable.complete?).to be_falsey
			expect(relation.target_deliverable.completed_by_id).to be_nil
		end

		it 'only creates tasks for creator and assignee' do
			observer_user = UserFactory.create(email: 'user@observer.com')
			assignee_user = UserFactory.create(email: 'assignee@assignee.com', first_name: 'Assignee', last_name: 'User')
			creator_user = UserFactory.create(email: 'creator@creator.com')
			observer_email = EmailFactory.create(current_user: observer_user,
				from_address: creator_user.email,
				to_addresses: [observer_user.name_and_email, assignee_user.name_and_email],
				snippet: 'Assignee, would you please do the thing')
			assignee_email = EmailFactory.create(current_user: assignee_user, from_email: observer_email)
			creator_email = EmailFactory.create(current_user: creator_user, from_email: observer_email)

			# Observer gets no deliverable.
			expect(DeliverableRelation.message(observer_email.message).count).to eq(0)
			RandyPleaseProcessor.new(observer_email).run
			expect(DeliverableRelation.message(observer_email.message).count).to eq(0)

			# Creator gets deliverable.
			expect(DeliverableRelation.message(creator_email.message).count).to eq(0)
			RandyPleaseProcessor.new(creator_email).run
			creator_deliverables = DeliverableRelation.message(creator_email.message).map(&:target_deliverable)
			expect(creator_deliverables.count).to eq(1)

			# Assignee gets deliverable.
			expect(DeliverableRelation.message(assignee_email.message).count).to eq(0)
			RandyPleaseProcessor.new(assignee_email).run
			assignee_deliverables = DeliverableRelation.message(assignee_email.message).map(&:target_deliverable)
			expect(assignee_deliverables.count).to eq(1)

			# Creator and assignee deliverables are different.
			expect(creator_deliverables.first.id).not_to eq(assignee_deliverables.first.id)
		end
	end
end
