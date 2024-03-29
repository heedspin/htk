source 'https://rubygems.org'

gem 'rails', '3.2.15'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'bootstrap-sass', '~> 3.2.0'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'autoprefixer-rails'
	# gem 'zurb-foundation'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'handlebars_assets'
end

gem 'json'
gem "jquery-rails", "< 3.0.0" # active_admin requires < 3.
# gem 'ember-rails', git: 'git://github.com/emberjs/ember-rails.git'
# gem 'ember-source', '1.2.0.1'
# gem 'handlebars-source'#, '1.0.0.rc3'
gem 'active_hash'

if File.exists?('../plutolib')
  gem 'plutolib', :path => '../plutolib'
else
  gem 'plutolib', :git => 'https://github.com/heedspin/plutolib.git'
end

if File.exists?('../google-api-ruby-client')
  gem 'google-api-client', :path => '../google-api-ruby-client', :require => 'google/api_client'
else
  gem 'google-api-client', :git => 'https://github.com/heedspin/google-api-ruby-client.git'
end

gem 'pg'
gem 'devise', '3.0.2'
gem 'activeadmin'
gem 'oauth'
gem 'html_press'
gem 'active_model_serializers'
gem 'airbrake'

# http://stackoverflow.com/questions/1226302/how-to-monitor-delayed-job-with-monit
gem 'delayed_job_active_record'
gem 'daemons'

group :development do
  gem 'annotate', :git => 'https://github.com/ctran/annotate_models.git'
  gem 'quiet_assets' #, :group => :development
end

group :development, :test do
  gem 'qunit-rails'
  gem 'rspec-rails'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
gem 'byebug'
