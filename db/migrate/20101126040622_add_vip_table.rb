class AddVipTable < ActiveRecord::Migration
  def self.up
    create_table :vips do |t|
      t.string :description 
      t.string :ipaddr
      t.string :puppet_variable_name
      t.integer :location_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :vips
  end
end
