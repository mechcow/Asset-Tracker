class Role < ActiveRecord::Base
  has_and_belongs_to_many :machines

  validates_numericality_of :extra_log_size,
    :only_integer => true,
    :message      => "Extra log size must be a number (in GB)",
    :allow_nil    => true

  validates_numericality_of :required_swap,
    :only_integer => true,
    :message      => "Swap must be a number (in MB)",
    :allow_nil    => true

  def self.base
    Role.find( :first, :conditions => { :name => "base" } )
  end
end
