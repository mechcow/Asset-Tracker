class ModifyInterfaces < ActiveRecord::Migration
  def self.up
    add_column "interfaces", "asset_id", :integer
    add_column "interfaces", "ipaddr", :string
    add_column "interfaces", "type", :string
  end

  def self.down
    remove_column "interfaces", "asset_id"
    remove_column "interfaces", "ipaddr"
    remove_column "interfaces", "type"
  end
end
