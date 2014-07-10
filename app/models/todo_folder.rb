require 'plutolib/stateless_delayed_job'

class TodoFolder
  include Plutolib::StatelessDelayedJob
  attr :permission
  def initialize(thing)
    if thing.is_a?(Permission)
      @permission = thing
    elsif thing.is_a?(Deliverable)
      @deliverable = thing
    end
  end

  def deliverable
    @deliverable ||= self.permission.deliverable
  end

  def each_email(&block)
    first_relation = self.deliverable.target_relations.tree.by_date.first
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

  def each_user(&block)
    if self.permission
      yield(self.permission.user)
    else
      self.deliverable.users.each(&block)
    end
  end

  def create
    if self.deliverable.complete?
      log "Already complete"
    else
      self.each_email do |email_account, email|
        self.each_user do |user|
          todo_folder = email_account.user.preferences.todo_folder_path(user)
          log "Create TODO(#{email_account.username}): #{email.subject} => #{todo_folder.join('/')}"
          email_account.assign_folder(todo_folder, email)
        end
      end
    end
  end

  def remove
    self.each_email do |email_account, email|
      self.each_user do |user|
        todo_folder = email_account.user.preferences.todo_folder_path(user)
        log "Remove TODO(#{email_account.username}): #{email.subject} X-> #{todo_folder.join('/')}"
        email_account.unassign_folder(todo_folder, email)
      end
    end
  end
end