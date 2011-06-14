class VirtualMachine < Machine
  belongs_to            :parent, :class_name => "PhysicalMachine"
  validates_presence_of :parent

  before_validation     :default_values

  # Commented out while fixing AssetController#create
  # validates_length_of   :interfaces,
  #                       :minimum => 1,
  #                       :too_short => "guests require at least {{count}} interface"

  def default_values
    self.disk_space ||= 10240
  end

  def swap
    @swap ||= roles.inject(0) { |sum,role| sum += role.required_swap}
  end

end
