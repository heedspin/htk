namespace :htk do
  desc "Create default users"
  task :create_default_users => :environment do
    AppConfig.default_users.each do |user_config|
      next if User.find_by_email(user_config['email'])
      u = User.new(:email => user_config['email'])
      password = u.password_confirmation = user_config['password']
      u.save(:validate => false)
    end
  end
end
