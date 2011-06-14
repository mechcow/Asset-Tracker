class AddVcpus < ActiveRecord::Migration
  def self.up
    add_column "assets", "vcpus", :integer
    add_column "assets", "fqdn", :string
  end

  def self.down
    remove_column "assets", "vcpus", :integer
    remove_column "assets", "fqdn", :string
  end
end

