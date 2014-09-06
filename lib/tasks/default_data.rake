namespace :htk do
  desc "Create default users"
  task :create_default_users => :environment do
    AppConfig.default_users.each do |user_config|
      next if User.find_by_email(user_config['email'])
      user_group = raise 'implement me'
      u = User.build(email: user_config['email'], status: UserStatus.active, user_group_id: user_group.id)
      u.password = u.password_confirmation = user_config['password']
      u.save!
    end
  end
end
