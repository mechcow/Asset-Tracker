class AddCpuColumn < ActiveRecord::Migration
  def self.up
    remove_column "assets", "cpu"
    add_column "assets", "cpu", :string
  end

  def self.down
    remove_column "assets", "cpu"
    add_column "assets", "cpu", :float
  end
end
