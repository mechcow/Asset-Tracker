class AddVgnameToAsset < ActiveRecord::Migration
  def self.up
    add_column "assets", "vgname", :string
  end

  def self.down
    remove_column "assets", "vgname", :string
  end
end
