Delayed::Worker.max_attempts = 1
Delayed::Worker.max_run_time = 6.hours
Delayed::Worker.logger = ActiveSupport::BufferedLogger.new("log/#{Rails.env}_delayed_jobs.log", Rails.logger.level)
Delayed::Worker.logger.auto_flushing = 1

if ENV.member? 'MONIT_SERVICE'
  AppConfig.delayed_job = true
  ActiveRecord::Base.logger = Delayed::Worker.logger
else
  AppConfig.delayed_job = false
end

Delayed::Worker.logger.info "DelayedJobConfig: delayed_job = #{AppConfig.delayed_job}"
if Rails.env.development?
  Delayed::Worker.destroy_failed_jobs = false
end
