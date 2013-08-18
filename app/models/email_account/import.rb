require 'plutolib/stateless_delayed_job'

class EmailAccount::Import
  include Plutolib::StatelessDelayedJob

  # EmailAccount::Import.new.import_all
  # */5 * * * * /var/www/htk/script/runner.sh 'EmailAccount::Import.new.delay.import_all'
  def import_all
    EmailAccount.active.each do |email_account|
      log "Importing #{email_account.username}"
      email_account.loggers = self.loggers
      email_account.import_emails
      log "Done importing #{email_account.username}"
    end
    true
  end
end
