source 'https://rubygems.org'

gem 'rails', '3.2.15'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
	gem 'zurb-foundation'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'json'
gem "jquery-rails", "< 3.0.0" # active_admin requires < 3.
# gem "ember-rails" #, "~> 0.13.0"
gem 'ember-rails', git: 'git://github.com/emberjs/ember-rails.git'
gem 'ember-source', '1.2.0.1'
gem 'handlebars-source'#, '1.0.0.rc3'
gem 'active_hash'

if File.exists?('../plutolib')
  gem 'plutolib', :path => '../plutolib'
else
  gem 'plutolib', :git => 'git@github.com:heedspin/plutolib.git'
end

gem 'pg'
gem 'devise'
gem 'activeadmin'
gem 'oauth'
gem 'html_press'

group :development do
  gem 'annotate', :git => 'https://github.com/ctran/annotate_models.git'
  gem 'quiet_assets' #, :group => :development
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
gem 'debugger'
