module BelongsToUserGroup
  def self.included(base)
  	base.class_eval <<-RUBY
		  belongs_to :user_group
		  def self.user_group(uog)
		    user_group_id = uog.is_a?(User) ? uog.user_group_id : (uog.is_a?(UserGroup) ? uog.id : uog)
		    where user_group_id: user_group_id
		  end
    RUBY
	end
end