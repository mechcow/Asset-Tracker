class Machine < ActiveRecord::Base
  include Inventoriable

  has_and_belongs_to_many :roles
  has_many                :interfaces, :dependent => :destroy

  validates_associated    :interfaces
  validates_format_of     :name,
                          :with => /\A[a-zA-Z0-9\-\_]+\.[a-zA-Z0-9\-\_\.]+\Z/,
                          :message => "FQDN contains invalid characters or does not contain a ."


  after_update :save_interfaces
  before_save :add_base_role

  def add_base_role
    base = Role.base
    self.roles << base unless self.role_ids.include? base.id
  end

  def vgname
    vgname_attribute = read_attribute(:vgname)
    if !vgname_attribute.blank? 
      vgname_attribute
    else
      shortname
    end
  end

  def clone_with_associations
    kopy = clone :include => [:interfaces,:asset]
    kopy.roles = roles
    kopy.asset.tags = asset.tags
    kopy.interfaces.each do |interface|
      interface.tags = interfaces.detect{|i| i.name == interface.name}.tags  
    end
    kopy
  end

  def main_if
    tags = [ MANAGEMENT_INTERFACE_TAG, "drbd", "vpn" ]
    tags.each { |tag| 
      iface = self.interfaces.named(tag).first
      if not iface.nil?
        return iface
      end
    }
    self.interfaces.first
  end

  def main_ip
    return nil if self.main_if.nil?
    self.main_if.ipaddr
  end

  def new_interface_attributes=(interface_attributes)
    interface_attributes.each do |attributes|
      interfaces.build(attributes)
    end
  end

  def interface_attributes=(interface_attributes)
    interfaces.reject(&:new_record?).each do |interface|
      attributes = interface_attributes[interface.id.to_s]
      if attributes
        interface.attributes = attributes
      else
        interface.delete(interface)
      end
    end
  end

  def save_interfaces
    interfaces.each do |interface|
      interface.save(false)
    end
  end

  def respond_to?(method_sym, include_private = false)
    if method_sym.to_s =~ /^(.*)_(if|ip)$/ and self.interfaces.tagged_with($1).any?
      true
    else
      #Let ActiveRecord handle this
      super
    end
  end

  def method_missing(sym, *args, &block)
    if sym.to_s =~ /^(.*)_(if|ip)$/ and self.interfaces.tagged_with($1).any?
      iface = self.interfaces.tagged_with($1).first
      if $2 == "if"
        iface
      else
        iface.ipaddr
      end
    else
      #Let ActiveRecord do its magic
      super
    end
  end

end
