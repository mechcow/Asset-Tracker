class CreateInventoriable < ActiveRecord::Migration
  class Asset < ActiveRecord::Base
    has_and_belongs_to_many :roles, :class_name => "CreateInventoriable::Role"
  end
  class Role < ActiveRecord::Base
    has_and_belongs_to_many :assets, :class_name => "CreateInventoriable::Asset"
  end

  class NewAsset < ActiveRecord::Base; end

  class Machine < ActiveRecord::Base
    has_and_belongs_to_many :new_roles, :class_name => "CreateInventoriable::NewRole"
  end
  class NewRole < ActiveRecord::Base
    has_and_belongs_to_many :machines, :class_name => "CreateInventoriable::Machine"
  end

  class Interface < ActiveRecord::Base;end

  def self.up

    new_ids = {}
    create_table :machines do |t|
      t.string  :type, :null => false
      t.string  :cpu, :disk_type, :vgname
      t.boolean  :isdom0, :default => false
      t.integer :ram, :vcpus, :disk_space,:parent_id
    end

    create_table :new_assets do |t|
      t.integer :user_id, :null => false
      t.integer :inventoriable_id, :location_id, :model_id
      t.string  :inventoriable_type, :name, :notes, :serial
    end

    create_table :new_roles do |t|
      t.integer :required_swap, :default => 0
      t.integer :extra_log_size
      t.string  :name
    end

    create_table :machines_new_roles, :id =>false do |t|
      t.references :new_role, :machine
    end

    Machine.reset_column_information
    NewAsset.reset_column_information
    NewRole.reset_column_information

    #Current asset table is not very big and loading all of them in memory shouldn't be a problem
    #Rails >=2.3 provides a find_in_batches which is better suited for this task
    Asset.all(:order => "isdom0 DESC",:include => :roles).each do |asset|
      m = Machine.new(  :cpu        => asset.cpu,
                        :vcpus      => asset.vcpus,
                        :disk_type  => asset.disk_type,
                        :disk_space => asset.disk_space,
                        :vgname     => asset.vgname,
                        :ram        => asset.ram)

      if !asset.isdom0 and asset.parent_id 
        m[:type] = "VirtualMachine"
        #At this point we have already processed all dom0s, so we should have its new id
        m.parent_id = new_ids[asset.parent_id] 
      else
        m.isdom0 = asset.isdom0
        m[:type] = "PhysicalMachine"
      end
      m.save

      NewAsset.create (  :inventoriable_id => m.id, 
                         :inventoriable_type => "Machine",
                         :name => asset.fqdn,
                         :notes => asset.notes,
                         :serial => asset.serial,
                         :user_id => asset.user_id,
                         :model_id => asset.model_id,
                         :location_id => asset.location_id
                      )
      new_ids[asset.id] = m.id

      # Migrate Roles to its new table and remove duplicates
      asset.roles.each do |role|
        m.new_roles << NewRole.find_or_create_by_name(  :name           => role.name,
                                                        :extra_log_size => role.extra_log_size,
                                                        :required_swap  => role.required_swap
                                                     )
      end

    end

    drop_table    :assets
    rename_table  :new_assets,:assets
    drop_table    :roles
    drop_table    :assets_roles
    rename_table  :new_roles,:roles
    rename_table  :machines_new_roles, :machines_roles
    change_table  :machines_roles do |t|
      t.rename :new_role_id, :role_id
    end

    #Migrate Interfaces
    Interface.all.each do |interface|
      interface.asset_id = new_ids[interface.asset_id]
      interface.save
    end

    change_table :interfaces do |t|
      t.rename :asset_id,:machine_id
    end

  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end
