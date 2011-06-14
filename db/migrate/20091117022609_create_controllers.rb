class CreateControllers < ActiveRecord::Migration
  def self.up
    create_table :controllers do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :controllers
  end
end
