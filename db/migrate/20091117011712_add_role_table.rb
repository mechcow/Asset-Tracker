class AddRoleTable < ActiveRecord::Migration
  def self.up
    create_table :role do |t|
      t.string :name, :null => false
    end
    remove_column "assets", "role"
    add_column "assets", "role_id", :integer
  end

  def self.down
    drop_table :role
    remove_column "assets", "role_id"
    add_column "assets", "role", :string
  end
end
