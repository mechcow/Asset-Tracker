class Location < ActiveRecord::Base
  
  has_many :assets
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :timezone
  validates_presence_of :dns
  validates_presence_of :puppetmaster_ip
  validates_presence_of :centos_ip

  validates_numericality_of :vifs

  named_scope :named, lambda{ |name| {:conditions => ['locations.name ILIKE ?', "%#{name}%" ] } }
end
