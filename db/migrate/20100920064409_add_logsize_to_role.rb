class AddLogsizeToRole < ActiveRecord::Migration
  def self.up
    add_column "roles", "extra_log_size", :integer
  end

  def self.down
    remove_column "roles", "extra_log_size"
  end
end
