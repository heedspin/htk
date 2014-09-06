require 'rails_helper'
require 'randy_please_processor'
require 'import_single_email'

RSpec.describe RandyPleaseProcessor, :type => :model do
	context 'regular expressions' do
		it 'recognizes the hot phrases' do
			john_doe = UserFactory.create(name: 'John Doe', email: 'john@doe.com')
			[ 
				{ 
					text:	'John, would you please send me your chocolate? Lorem ipsum dolor sit amet, consectetur adipiscing elit',
					first_names_to_users: { 
						'joe' =>  john_doe,
						'john' => john_doe
					},
					expect_name: 'John Doe',
					expect_pleasm: 'would you',
					expect_task: 'send me your chocolate'
				},

				{
					text: 'Some, please do the thing',
					first_names_to_users: {
						'some' => UserFactory.create(name: 'Some User', email: 'doesnot@matter.com')
					},
					expect_name: 'Some User',
					expect_pleasm: 'please',
					expect_task: 'do the thing'
				}
			].each do |test_config|
				results = RandyPleaseProcessor::Pleasm.parse(test_config[:first_names_to_users], test_config[:text])
				expect(results.size).to eq(1), "for #{test_config[:text]}"
				expect pleasm = results[0]
				expect(pleasm.assignee.name).to eq(test_config[:expect_name])
				expect(pleasm.pleasm).to eq(test_config[:expect_pleasm])
				expect(pleasm.task).to eq(test_config[:expect_task])
			end
		end
	end

	# rspec spec/models/randy_please_processor_spec.rb -e 'users and permissions'
	context 'users and permissions' do
		it 'creates a surrogate user for non group significants' do
			current_user = UserFactory.create(email: 'testuser@htk.com', first_name: 'Test', last_name: 'User')
			from_address = 'someone@company1.com'
			assignee_email_address = 'someone@company2.com'
			email = EmailFactory.create(current_user: current_user, 
				from_address: from_address, 
				to_addresses: [current_user.email, "Some One <#{assignee_email_address}>"],
				cc_addresses: ['someone@company3.com'],
				snippet: 'Some, please do the thing')
			expect(DeliverableRelation.message(email.message).count).to eq(0)
			expect(User.surrogate.email(from_address).count).to eq(0)
			expect(User.email(assignee_email_address).surrogate.count).to eq(0)
			RandyPleaseProcessor.new(email).run
			expect(DeliverableRelation.message(email.message).count).to eq(1)
			expect(User.surrogate.email(from_address).user_group(current_user.user_group_id).count).to eq(1)
			expect(User.surrogate.email(assignee_email_address).user_group(current_user.user_group_id).count).to eq(1)
		end
	end

	context 'tasks' do
		it 'opens and closes a task' do
	    emails = []
	    task_email = nil
	    done_email = nil
			expect(User.email('tharrison@lxdinc.com').count).to eq(0)
	    TestGmails.by_date(:chocolate_procurement).each do |email_address, message|
	      user = User.find_by_email(email_address) || UserFactory.create(email: email_address)
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

	  	# Owner
	  	owners = relation.target_deliverable.permissions.owner.all
	  	expect(owners.size).to eq(1)
	  	owner = owners.first.user
	  	expect(owner).to eq(task_email.from_user)
			expect(owner.email).to eq('tim@126bps.com')

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
	    TestGmails.by_date(:chocolate_procurement, except: ['14804ad5ff61cc88', '14804ad611214514']).each do |email_address, message|
	      user = User.find_by_email(email_address) || UserFactory.create(email: email_address)
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

	end
end
