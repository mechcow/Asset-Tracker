class Interface < ActiveRecord::Base
  after_save   :assign_tags

  belongs_to  :machine
  has_many    :slaves, :class_name => "Interface",  :foreign_key => "master_id" 
  belongs_to  :master, :class_name => "Interface"

  validates_format_of :name,
  :with    => /(eth|bond)[0-9]/,
  :message => "interface name not recognized"

  validates_format_of :ipaddr,
  :with    =>    /\A(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)(?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}\z/, #http://www.ruby-forum.com/topic/62553
  :message => "IP Address was not valid",
  :if      => :ipaddr? 

  validates_uniqueness_of :ipaddr,
  :if      => :ipaddr? 

  validates_format_of :netmask,
  :with    =>    /\A(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)(?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}\z/, #http://www.ruby-forum.com/topic/62553
  :message => "Netmask was not valid, should be in 255.255.0.0 format",
  :if      => :netmask?

  validates_presence_of :type

  def self.tags_like(tag_name)
    Tag.type("Interface").named(tag_name).map(&:name)
  end

  def self.free_ips_like(ip)
    ip_addresses = Interface.with_ips_like(ip).map(&:ipaddr)
    ip_addresses = ip_addresses + Vip.with_ips_like(ip).map(&:ipaddr)
    free_ips = ip_addresses.map do |ip|
      last_number = ip.split('.')[3].to_i
      last_number = last_number + 1 
      last_number = 254 if last_number > 254 
      (ip.split('.')[0..2] << last_number.to_s).join('.')
    end 
    ip_addresses = free_ips.uniq - ip_addresses
  end

  named_scope :tagged_with, lambda{ |name| {:joins => :tags ,:conditions => ['tags.name ILIKE ?', "#{name}" ] } }
  named_scope :named, lambda{ |name| {:joins => :tags ,:conditions => ['tags.name ILIKE ?', "%#{name}%" ] } }
  named_scope :with_ips_like, lambda{ |ip| {:conditions => [ 'ipaddr LIKE ?', "%#{ip}%" ], 
                                            :order      => "ipaddr"}}

  def validate
    errors.add :ipaddr, "IP Address is already allocated in a VIP" if Vip.find_by_ipaddr(ipaddr)
  end

end
