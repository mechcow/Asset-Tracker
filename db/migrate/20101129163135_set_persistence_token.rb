class SetPersistenceToken < ActiveRecord::Migration
  class User<ActiveRecord::Base;end

  def self.up
    User.reset_column_information
    User.all.each do |user|
      user.persistence_token = user.id
      user.save
    end
  end

  def self.down
    User.update_all("persistence_token = ''")
  end
end
