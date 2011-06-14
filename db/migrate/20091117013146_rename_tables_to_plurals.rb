class RenameTablesToPlurals < ActiveRecord::Migration
  def self.up
    rename_table "role", "roles"
    rename_table "environment", "environments"
  end

  def self.down
    rename_table "roles", "role"
    rename_table "environments", "environment"
  end
end
