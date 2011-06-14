class AddTagsToInterfaces < ActiveRecord::Migration
  class Interface < ActiveRecord::Base;end 
  class Tag < ActiveRecord::Base;end
  class Tagging < ActiveRecord::Base;end

  def self.up
    tags = {}
    Interface.all.each do |interface|
      name = interface.interface_type
      unless name.blank?
        tags[name] = Tag.create(:name => name).id unless tags.has_key? name
        Tagging.create(:tag_id => tags[name], :taggable_id => interface.id, :taggable_type => "Interface" )
        interface.save
      end
    end
    remove_column :interfaces,:interface_type
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
