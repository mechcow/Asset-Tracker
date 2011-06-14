class AddMasterToInterfaces < ActiveRecord::Migration
  def self.up
    add_column "interfaces", "master_id", :integer
  end

  def self.down
    remove_column "interfaces", "master_id"
  end
end
