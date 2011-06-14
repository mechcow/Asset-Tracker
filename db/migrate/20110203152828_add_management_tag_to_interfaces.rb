class AddManagementTagToInterfaces < ActiveRecord::Migration
  class Tag < ActiveRecord::Base;end
  class Tagging < ActiveRecord::Base;end

  def self.up
    #Add "management" tag to drbd interfaces
    management_tag = Tag.create(:name => "management")
    drbd_tag = Tag.find_by_name("drbd") 
    drbd_tag ||= Tag.create(:name => "drbd")
    Tagging.all(:conditions => { :tag_id => drbd_tag.id }).each do |tagging|
      Tagging.create( :tag_id => management_tag.id,
                      :taggable_id => tagging.taggable_id,
                      :taggable_type => tagging.taggable_type  
                    )
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
