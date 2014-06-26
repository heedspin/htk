require 'plutolib/stateless_delayed_job'

class DeliverableFolder
  include Plutolib::StatelessDelayedJob
  attr :deliverable_relation
  def initialize(deliverable_relation)
  	@deliverable_relation = deliverable_relation
  end

  def deliverable
    @deliverable ||= self.deliverable_relation.target_deliverable
  end

  def email_account_threads
    self.deliverable_relation.message_thread.email_account_threads.accessible_to_deliverable(self.deliverable)
  end

  # Label every email in this relation's thread for every user.
  def copy_all_to_folder
  	log "DeliverableFolder.copy_all_to_folder for #{self.deliverable.title}"
  	self.email_account_threads.each do |eat|
  		email_account = eat.email_account
			label_path = email_account.user.preferences.folder_path_for(self.deliverable)
			email_account.assign_folder(label_path, eat.emails)
  	end
  end

  def copy_email_to_folder(email)
  	email_account = email.email_account
		label_path = email_account.user.preferences.folder_path_for(self.deliverable)
		email_account.assign_folder(label_path, email)
  end

  # Remove this thread's messages from this deliverable folder.
  # Remove folder if it is empty.
  def remove_all_from_folder
    log "DeliverableFolder.remove_all_from_folder for #{self.deliverable.title}"
    self.email_account_threads.each do |eat|
      email_account = eat.email_account
      folder_path = email_account.user.preferences.folder_path_for(self.deliverable)
      email_account.unassign_folder(folder_path, eat.emails)
    end
  end

  def rename_folder(from_deliverable_path)
    from_path = from_deliverable_path.join('/')
    log "DeliverableFolder.rename_folder from #{from_path} to ../#{self.deliverable.title}"
    self.email_account_threads.each do |eat|
      email_account = eat.email_account
      from_folder_path = email_account.user.preferences.folder_path_for(from_deliverable_path)
      folder_path = email_account.user.preferences.folder_path_for(self.deliverable)
      email_account.rename_folder(from_folder_path, folder_path)
    end
  end
end