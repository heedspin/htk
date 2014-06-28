require 'plutolib/stateless_delayed_job'

class TodoFolder
  include Plutolib::StatelessDelayedJob
  attr :deliverable_user
  def initialize(deliverable_user)
  	@deliverable_user = deliverable_user
  end

  def deliverable
    @deliverable ||= self.deliverable_user.deliverable
  end

  def each_email(&block)
    first_relation = self.deliverable.target_relations.tree.not_deleted.by_date.first
    if message_id = first_relation.try(:message_id)
      self.deliverable.users.each do |user|
        user.email_accounts.each do |email_account|
          email_account.emails.message(message_id).each do |email|
            yield email_account, email
          end
        end
      end
    else
      log "No message"
    end
  end

  def create_todo
    if self.deliverable.complete?
      log "Already complete"
    else
      self.each_email do |email_account, email|
        todo_folder = email_account.user.preferences.todo_folder_path(self.deliverable_user.user)
        log "Create TODO(#{email_account.username}): #{email.subject} => #{todo_folder.join('/')}"
        email_account.assign_folder(todo_folder, email)
      end
    end
  end

  def remove_todo
    self.each_email do |email_account, email|
      email_account = email.email_account
      todo_folder = email_account.user.preferences.todo_folder_path(self.deliverable_user.user)
      log "Remove TODO(#{email_account.username}): #{email.subject} X-> #{todo_folder.join('/')}"
      email_account.unassign_folder(todo_folder, email)
    end
  end
end