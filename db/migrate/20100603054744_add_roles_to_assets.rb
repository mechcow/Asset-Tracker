class AddRolesToAssets < ActiveRecord::Migration
  def self.up
    create_table :assets_roles, :id => false do |t|
      t.references :asset
      t.references :role
      t.timestamps
    end
  end

  def self.down
    drop_table :assets_roles
  end
end
