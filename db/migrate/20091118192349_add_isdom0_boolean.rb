class AddIsdom0Boolean < ActiveRecord::Migration
  def self.up
    add_column "assets", "isdom0", :boolean
  end

  def self.down
    remove_column "assets", "isdom0"
  end
end
