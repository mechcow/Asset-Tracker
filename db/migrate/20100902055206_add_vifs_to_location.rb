class AddVifsToLocation < ActiveRecord::Migration
  def self.up
    add_column "locations", "vifs", :integer
  end

  def self.down
    remove_column "locations", "vifs", :integer
  end
end
