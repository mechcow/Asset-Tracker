class AddInterfaceName < ActiveRecord::Migration
  def self.up
    add_column "interfaces", "name", :string
  end

  def self.down
    remove_column "interfaces", "name"
  end
end
