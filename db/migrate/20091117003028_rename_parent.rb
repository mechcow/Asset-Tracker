class RenameParent < ActiveRecord::Migration
  def self.up
    rename_column "assets", "parent", "parent_id"
  end

  def self.down
    rename_column "assets", "parent_id", "parent"
  end
end
