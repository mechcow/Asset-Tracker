class PhysicalMachine < Machine
  has_many :guests, :class_name => "VirtualMachine", :foreign_key => "parent_id"

  named_scope :acting_as_hypervisors, :conditions => {:isdom0 => true}
end
