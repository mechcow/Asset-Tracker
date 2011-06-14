class RenameInterfaceTypeColumn < ActiveRecord::Migration
  def self.up
    rename_column "interfaces", "type", "interface_type"
  end

  def self.down
    rename_column "interfaces", "interface_type", "type"
  end
end
