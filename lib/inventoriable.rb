module Inventoriable

  module ClassMethods
    #Build new objects with an associated asset
    def new_with_asset(attributes=nil)
      model = self.new(attributes) 
      model.build_asset 
      model
    end 

    #Each inventoriable type should handle its associations
    def new_with_associations
      raise "Method not implemented, please define \"self.new_with_associations\" in #{model_name.to_s}"
    end

    def validate_fqdn?
      false
    end
  end

  def self.included(base)
    base.has_one              :asset, :as =>:inventoriable, :dependent => :destroy
    base.validates_associated :asset

    base.after_update         :save_asset
    base.extend(ClassMethods)
#    base.default_scope  :include => :asset
    base.named_scope          :located, lambda{ |name| {:joins => { :asset => :location  },:conditions => ['locations.name LIKE ?', "#{name}" ] } } 
    base.named_scope          :tagged, lambda{ |name| {:joins => { :asset => :tags  },:conditions => ['tags.name ILIKE ?', "#{name}" ] } }

    delegate            :name,        :name=, 
                        :fqdn,        :fqdn=,
                        :location,    :location=,
                        :location_id, :location_id=,
                        :notes,       :notes=,
                        :serial,      :serial=,
                        :user,        :user=,
                        :user_id,     :user_id,
                        :model,       :model=,
                        :model_id,    :model_id=,
                        :tag_names,   :tag_names=,
                        :tags,
                        :shortname,
                        :named_role,
                        :number,
                        :cluster,
                        :env,
                        :parent_puppet_class,
                        :domain,
                        :to => :asset
  end

  #Each inventoriable type should handle the cloning operation
  def clone_with_associations
    raise "Method not implemented, please define \"clone_with_associations\" in #{model_name.to_s}"
  end

  def underscore_name
    self.class.to_s.underscore
  end

  def underscore_inventoriable_type
    asset.inventoriable_type.pluralize.underscore
  end

  def save_asset
    asset.save(false)
  end


  #Rails 2.2 does not provide support for Nested Forms, this will have to be removed and the forms fixed after the upgrade
  def asset_attributes=(attributes)
    unless asset.new_record?
      asset.attributes = attributes
    end
  end
  def new_asset_attributes=(asset_attr)
    build_asset(asset_attr)
  end

end
