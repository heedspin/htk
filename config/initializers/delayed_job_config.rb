Delayed::Worker.max_attempts = 1
Delayed::Worker.max_run_time = 6.hours
Delayed::Worker.destroy_failed_jobs = false if Rails.env.development?

if ENV.member? 'DJ_STDOUT'
	# export DJ_STDOUT=hi
	# bundle exec rake jobs:work
  Delayed::Worker.logger = Logger.new(STDOUT)
  AppConfig.delayed_job = true
elsif ENV.member? 'MONIT_SERVICE'
	Delayed::Worker.logger = ActiveSupport::BufferedLogger.new("log/#{Rails.env}_delayed_jobs.log", Rails.logger.level)
	Delayed::Worker.logger.auto_flushing = 1
  AppConfig.delayed_job = true
else
  AppConfig.delayed_job = false
end

if AppConfig.delayed_job
  ActiveRecord::Base.logger = Delayed::Worker.logger
  Delayed::Worker.logger.info "DelayedJobConfig: delayed_job = #{AppConfig.delayed_job}"
end

