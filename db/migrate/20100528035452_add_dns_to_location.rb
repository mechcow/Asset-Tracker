class AddDnsToLocation < ActiveRecord::Migration
  def self.up
    add_column "locations", "dns", :string
  end

  def self.down
    remove_column "locations", "dns"
  end
end
