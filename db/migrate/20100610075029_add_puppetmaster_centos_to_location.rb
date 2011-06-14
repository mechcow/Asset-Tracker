class AddPuppetmasterCentosToLocation < ActiveRecord::Migration
  def self.up
    add_column "locations", "puppetmaster_ip", :string
    add_column "locations", "centos_ip", :string
  end

  def self.down
    remove_column "locations", "puppetmaster_ip", :string
    remove_column "locations", "centos_ip", :string
  end
end
