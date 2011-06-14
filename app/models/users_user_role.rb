# The table that links roles with users (generally named RoleUser.rb)
class UsersUserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
end
