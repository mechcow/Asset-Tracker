class AddColumnsToInterfaces < ActiveRecord::Migration
  def self.up
    drop_table :interface
    add_column "interfaces", "mac", :string
    add_column "interfaces", "mtu", :integer
    add_column "interfaces", "gateway", :string
    add_column "interfaces", "netmask", :string
  end

  def self.down
    create_table :interface do |t|
      t.timestamps
    end
    remove_column "interfaces", "mac"
    remove_column "interfaces", "mtu"
    remove_column "interfaces", "gateway"
    remove_column "interfaces", "netmask"
  end
end
