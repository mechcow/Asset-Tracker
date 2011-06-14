class User < ActiveRecord::Base
  
  has_many :assets, :dependent => :destroy
  
  validates_presence_of :login
  validates_uniqueness_of :login
  
  validates_presence_of :email

  named_scope :named, lambda{ |name| {:conditions => ['users.login ILIKE ?', "%#{name}%" ] } }

  acts_as_authentic do |c|
    c.validate_password_field = false
  end

  # Authorization plugin
  acts_as_authorized_user
  acts_as_authorizable

  def has_role?(role, obj=nil)
    self.site_admin
  end

  def self.find_or_create_from_ldap(login)
    find_by_login(login) || create_from_ldap_if_valid(login)
  end

  def self.create_from_ldap_if_valid(login)
    p "create_from_ldap_if_valid"
    Ldap['ldaphost'].each do |ldaphost|
      if Ldap['ldapport'] == 389
        conn = LDAP::Conn.new(host=ldaphost, port=Ldap['ldapport'])
      else
        conn = LDAP::SSLConn.new(host=ldaphost, port=Ldap['ldapport'])
      end
      begin
        conn.search(Ldap['binddn'] % login, LDAP::LDAP_SCOPE_BASE, '(objectClass=inetOrgPerson)') { |person|
          p person.vals('mail')
          return User.create(:login => person.vals('uid')[0], :email => person.vals('mail')[0])
        }
      rescue LDAP::ResultError
        p "got result error"
        false
      end
    end
  end

  def get_conn
    @conn
  end

  protected

  def valid_ldap_credentials?(password_plaintext)
    Ldap['ldaphost'].each do |ldaphost|
      if Ldap['ldapport'] == 389
        @conn = LDAP::Conn.new(host=ldaphost, port=Ldap['ldapport'])
      else
        @conn = LDAP::SSLConn.new(host=ldaphost, port=Ldap['ldapport'])
      end
      p "testing with ldap host %s" % ldaphost
      begin
        if @conn.bind(Ldap['binddn'] % self.login,password_plaintext)
          p "searching for rwgroup"
          site_admin = false
          @conn.search(Ldap['rwgroup'], LDAP::LDAP_SCOPE_BASE, '(objectClass=groupofuniquenames)') { |rwgroup|
            p "found rwgroup"
            if rwgroup.vals('uniqueMember').include?(Ldap['binddn'] % self.login)
              p "setting site_admin true"
              site_admin = true
            end
          }
          self.site_admin = site_admin
          self.save
          require 'pp'
          pp self
          pp self.instance_variables
          return true
        end
      rescue LDAP::ResultError
        p "got result error"
        false
      end
    end
    return false
  end

end
