class XenInfo < ActiveRecord::Migration
  def self.up
    add_column "assets", "parent", :integer
    add_column "assets", "ram", :integer
    add_column "assets", "role", :string
    add_column "assets", "cpu", :float
    add_column "assets", "environment_id", :integer

    create_table :environment do |t|
      t.string :name, :null => false
    end

    create_table :interface do |t|
      t.string :ipaddr, :null => false
      t.references :asset, :null => false
    end
  end

  def self.down
    remove_column "assets", "parent", :integer
    remove_column "assets", "ram", :integer
    remove_column "assets", "role", :string
    remove_column "assets", "cpu", :float
    remove_column "assets", "environment", :references

    drop_table :environment
    drop_table :interface
  end
end
