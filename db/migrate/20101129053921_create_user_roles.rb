class CreateUserRoles < ActiveRecord::Migration

  def self.up
    create_table :user_roles_users, :id => false, :force => true  do |t|
      t.integer :user_id, :user_role_id
      t.timestamps
    end

    create_table :user_roles, :force => true do |t|
      t.string  :name, :authorizable_type, :limit => 40
      t.integer :authorizable_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_roles
    drop_table :user_roles_users
  end

end
