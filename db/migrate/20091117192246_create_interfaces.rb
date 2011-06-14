class CreateInterfaces < ActiveRecord::Migration
  def self.up
    create_table :interfaces do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :interfaces
  end
end
