class AddDiskColumns < ActiveRecord::Migration
  def self.up
    add_column "assets", "disk_space", :integer
    add_column "assets", "disk_type", :string
  end

  def self.down
    remove_column "assets", "disk_space"
    remove_column "assets", "disk_type"
  end
end
