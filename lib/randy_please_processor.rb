require 'plutolib/logger_utils'
require 'get_deliverable_tree'
class RandyPleaseProcessor
	include Plutolib::LoggerUtils
	include GetDeliverableTree
	attr :email, :current_user, :text
	def initialize(email)
		@email = email
		@current_user = email.user
		@text = @email.snippet
	end

	class Pleasm
		include Plutolib::LoggerUtils
		attr :pleasm, :task, :assignee
		def initialize(assignee, pleasm, task)
			@assignee = assignee
			@pleasm = pleasm
			@task = task
		end
		def self.parse(first_name_to_users, text)
			result = []
			if text
				first_names = first_name_to_users.keys.join('|')
				if first_names.size > 0
					hot_phrases = 'could you|would you|can you'
					regex = "\\b(#{first_names})\\W*\\b(#{hot_phrases})\\W*\\b([^\?\.]+)[\?\.]?"
					recognizer = Regexp.new regex, Regexp::IGNORECASE | Regexp::MULTILINE
					text.split(/[\.!\?]/).each do |sentence|
						# log "Running #{regex} against #{sentence}"
						if matches = recognizer.match(sentence)
							first_name = matches[1].downcase
							user = first_name_to_users[first_name]
							if user.nil?
								raise "No user matching #{first_name} for #{text}"
							end
							result.push Pleasm.new(user, matches[2], matches[3])
						end
					end
				end
			end
			result
		end
	end

	def run
		log "#{self.current_user.email} processing: #{self.text}"
		process_pleasms
		process_completes
	end

	def process_pleasms
		pleasms = Pleasm.parse(self.email.first_names_to_users, self.text)
		if pleasms.size > 0
			pleasms.each do |pleasm|
				if (self.email.from_user.user_group_id == self.current_user.user_group_id) or (pleasm.assignee.user_group_id == self.current_user.user_group_id)
					DeliverableRelation.message(self.email.message).includes(:target_deliverable).each do |relation|
						if relation.target_deliverable.title == pleasm.task
							log "#{self.current_user.email} already created: #{pleasm.assignee.name_and_email} => #{pleasm.pleasm} => #{pleasm.task}"
							return
						end
					end
					log "#{self.current_user.email} creating: #{pleasm.assignee.name_and_email} => #{pleasm.pleasm} => #{pleasm.task}"
					Deliverables::Standard.transaction do
						deliverable = Deliverables::Standard.create_from_email(current_user: self.current_user,
							email: self.email, 
							params: { title: pleasm.task,	description: self.text })
						# Create relations
						DeliverableRelation.create!(target_deliverable_id: deliverable.id, 
							status_id: LifeStatus.active.id, 
							relation_type_id: DeliverableRelationType.parent.id,
							message_thread_id: @email.message_thread.id,
							message_id: @email.message.id)
						# Create assignee user if one does not exist.
						if pleasm.assignee.new_record?
							pleasm.assignee.user_group_id = self.current_user.user_group_id
							pleasm.assignee.save!
						end
						# Create assignment permission.
						Permission.create!(user_id: pleasm.assignee.id, deliverable_id: deliverable.id, access: DeliverableAccess.edit, responsible: true)
					end
				else
					log "#{self.current_user.email} ignoring not-my-pleasm: #{pleasm.assignee.name_and_email} => #{pleasm.pleasm} => #{pleasm.task}"
				end
			end
		end
	end

	def incomplete_assignments
		relations = DeliverableRelation.message_or_thread(self.email.message.id, self.email.message.message_thread_id).not_deleted.top_level.all
		tree = get_deliverable_tree(relations: relations)
		tree[:permissions].select { |p| (p.user_id == self.email.from_user.id) && p.responsible && p.deliverable.incomplete? }
	end

	class Complete
		attr :phrase
		def initialize(phrase)
			@phrase = phrase
		end
		def self.parse(text)
			results = []
			if text =~ /(complete|finished|done)/i
				results.push new($1)
			end
			results
		end
	end

	def process_completes
		completes = Complete.parse(self.text)
		if (completes.size > 0) and ((assignments = self.incomplete_assignments).size > 0)
			if assignments.size == 1
				assignment = assignments.first
				complete = completes.first
				log "#{self.current_user.email}: Marking deliverable #{assignment.deliverable.title} as completed by #{self.email.from_user.email} from phrase #{complete.phrase} and email:\n#{self.text}"
				Deliverable.transaction do
					assignment.deliverable.comments.create! comment_type: DeliverableCommentType.complete, note: self.email.snippet, user: self.email.from_user
				end
			else
				log "#{self.current_user.email}: There are #{assignments.size} incomplete assignments. Do not know which one to mark complete."
			end
		end
	end
end