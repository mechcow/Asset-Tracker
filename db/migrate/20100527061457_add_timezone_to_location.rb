class AddTimezoneToLocation < ActiveRecord::Migration
  def self.up
    add_column "locations", "timezone", :string
  end

  def self.down
    remove_column "locations", "timezone"
  end
end
