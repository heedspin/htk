require 'plutolib/stateless_delayed_job'

class CopyToDeliverableFolder
  include Plutolib::StatelessDelayedJob
  def initialize(deliverable_relation)
  	@deliverable_relation_id = deliverable_relation.id
  end

  def deliverable_relation
  	@deliverable_relation ||= DeliverableRelation.find(@deliverable_relation_id)
  end

  def deliverable
    @deliverable ||= self.deliverable_relation.target_deliverable
  end

  # Label every email in this relation's thread for every user.
  def copy_all_to_folder
  	log "CopyToDeliverableFolder.copy_all_to_folder for #{self.deliverable.title}"
  	self.deliverable_relation.message_thread.email_account_threads.each do |eat|
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
end