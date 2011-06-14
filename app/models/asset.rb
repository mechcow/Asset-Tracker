class Asset < ActiveRecord::Base
  after_save   :assign_tags

  belongs_to :inventoriable, :polymorphic => true
  belongs_to :user
  belongs_to :model
  belongs_to :location

  validates_presence_of   :user
  validates_presence_of   :model
  validates_presence_of   :location
  validates_associated    :tags
  validates_uniqueness_of :name

  alias_attribute       :fqdn, :name

  #Named Scopes
  named_scope :tagged_with, lambda{ |name| {:joins => :tags ,:conditions => ['tags.name ILIKE ?', "#{name}" ] } }
  named_scope :named,    lambda{ |name| {:conditions => ['assets.name ILIKE ?', "%#{name}%" ] } }
  named_scope :location, lambda{ |location| 
    {:conditions => {:location_id => Location.find(:first,:conditions => ['name ILIKE ?',"%#{location}%"]).try(:id) } } 
  }

  def self.tags_like(tag_name)
    Tag.type("Asset").named(tag_name).map(&:name)
  end


  def <=>(other)
    self.fqdn <=> other.fqdn
  end

  def shortname
    self.fqdn.split(".")[0]
  end

  def domain
    self.fqdn.split(".")[1..-1].join(".") 
  end

  def parent_puppet_class
    if _parse_shortname
      "%s%s-%s" % [@cluster_number,@role,@env ? @env : "base"]
    else
      nil
    end
  end

  def number
    if _parse_shortname
      @number
    else
      nil
    end
  end

  def env
    if _parse_shortname
      @env
    else
      nil
    end
  end

  def cluster
    if _parse_shortname
      @cluster_number
    else
      nil
    end
  end

  def named_role
    if _parse_shortname
      @role
    else
      nil
    end
  end

  def _parse_shortname
    m = self.shortname.match(/^(c\d+)([A-z]+)(\d+)-(\w+)$/)
    if m
      @cluster_number = m[1]
      @role = m[2]
      @number = m[3]
      @env = m[4]
    elsif m = self.shortname.match(/^([A-z]+)(\d+)?-(\w+)$/)
      @cluster_number = nil
      @role = m[1]
      @number = m[2]
      @env = m[3]
    elsif m = self.shortname.match(/^([A-z]+)(\d+)$/)
      @cluster_number = nil
      @role = m[1]
      @number = m[2]
      @env = nil
    else
      nil
      return false
    end
    return true
  end
end
