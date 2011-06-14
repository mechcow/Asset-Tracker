class Vip < ActiveRecord::Base

  belongs_to :location
  
  validates_format_of :ipaddr,
    :with    =>    /\A(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)(?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}\z/, #http://www.ruby-forum.com/topic/62553
    :message => "IP Address was not valid"

  validates_format_of :puppet_variable_name,
    :with    =>   /[a-z][a-z_]*/,
    :message =>   "Puppet variable name not valid"

#  validates_uniqueness_of :ipaddr

  def <=>(other)
    self.ipaddr <=> other.ipaddr
  end
  
  named_scope :with_ips_like, lambda{ |ip| {:conditions => [ 'ipaddr LIKE ?', "%#{ip}%" ], 
                                            :order      => "ipaddr"}}
#  def validate
#    errors.add :ipaddr, "IP Address is already allocated in an interface" if Interface.find_by_ipaddr(ipaddr)
#  end

end
