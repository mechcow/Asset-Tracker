class AddSwapToRoles < ActiveRecord::Migration
  class Role < ActiveRecord::Base;end
  class Asset < ActiveRecord::Base;end

  def self.up
    add_column :roles, :required_swap, :integer, :default => 0 

    Role.reset_column_information
    Role.update_all("required_swap = 0")
    Role.update_all("required_swap = 512","name = 'base'")
    Role.update_all("required_swap = 4608","name = 'dwh'")
    Role.update_all("required_swap = 4096","name = 'summary'")
   # Asset.update_all("disk_space = 10240","isdom0 = false and parent_id IS NOT NULL")
  end

  def self.down
    remove_column :roles, :required_swap
  end
end
