#!/usr/bin/env ruby
=begin

Module for interacting with DNS objects within LDAP

@author Joel Heenan 10/11/2009

$HeadURL: http://svn.syd.int.threatmetrix.com/svn/tm/trunk/ops/asset_tracker/lib/LdapDns.rb $
$Id: LdapDns.rb 24334 2010-09-15 07:44:45Z ashapira $

25/11/09 - JH - added reverse DNS
=end

require 'ldap'
require 'ipaddr'
$VALID_DOMAINS = [ 'syd.int.threatmetrix.com', 'lsa.int.threatmetrix.com', 'bb.int.threatmetrix.com', 'drbd.bb.int.threatmetrix.com', 'iad.int.threatmetrix.com', 'lon.int.threatmetrix.com' ]

module LdapDns
  def self.add_domain(conn,domain)
    new_entry = [
      LDAP.mod(LDAP::LDAP_MOD_ADD,'objectclass',['dnszone']),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnszonename',[domain]),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'cn',[domain]),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnsclass',["IN"]),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnstype',["SOA"]),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnsminimum',["3600"]),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnsretry',["3600"]),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnsexpire',["3600"]),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnsrefresh',["10800"]),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnsserial',["12345"]),
    ]
    begin
      conn.add("cn=%s,ou=DNS,dc=thm" % [domain], new_entry)
    rescue LDAP::ResultError
    end
    conn.perror("add")

    $NS_SERVERS.each do |name,ipaddr|
      shortname = name.split(".")[0]
      new_entry = [
        LDAP.mod(LDAP::LDAP_MOD_ADD,'objectclass',['dnszone','dnsrrset']),
        LDAP.mod(LDAP::LDAP_MOD_ADD,'dnsipaddr',[ipaddr]),
        LDAP.mod(LDAP::LDAP_MOD_ADD,'dnscname',[name+"."]),
        LDAP.mod(LDAP::LDAP_MOD_ADD,'cn',[shortname]),
        LDAP.mod(LDAP::LDAP_MOD_ADD,'dnstype',["NS"]),
        LDAP.mod(LDAP::LDAP_MOD_ADD,'dnsclass',["IN"]),
      ]
      begin
        conn.add("cn=%s,cn=%s,ou=DNS,dc=thm" % [shortname,domain],new_entry)
      rescue LDAP::ResultError
      end
      conn.perror("add")
    end
  end

  def self.connect_ldap(ldaphost,ldapport,binddn,password)
    conn = LDAP::Conn.new(host=ldaphost, port=ldapport)
    conn.perror("connect")
    conn.bind(binddn,password)
    conn.perror("bind")
    conn
  end

  def self.add_a_record(conn, dnsname, ipaddr)
    cn,parent = self.split_cn_parent(dnsname)

    new_entry = [
      LDAP.mod(LDAP::LDAP_MOD_ADD,'objectclass',['dnszone','dnsrrset']),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnsipaddr',[ipaddr]),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnsdomainname',[cn]),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnstype',["A"]),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnsclass',["IN"]),
    ]
    begin
      conn.add("cn=%s,cn=%s,ou=DNS,dc=thm" % [cn,parent], new_entry)
    rescue LDAP::ResultError
    end
    conn.perror("add")
  end

  def self.add_reverse_record(conn, dnsname, ipaddr)
    lastdigit = ipaddr.split(".")[3]
    reverse_domain = self.get_reverse_domain(ipaddr)

    new_entry = [
      LDAP.mod(LDAP::LDAP_MOD_ADD,'objectclass',['dnszone','dnsrrset']),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'cn',[lastdigit]),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnsdomainname',[lastdigit]),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnstype',["PTR"]),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnsclass',["IN"]),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnscname',[dnsname + "."]),
    ]
    begin
      conn.add("cn=%s,cn=%s,ou=DNS,dc=thm" % [lastdigit,reverse_domain], new_entry)
    rescue LDAP::ResultError
    end
    conn.perror("add")
  end

  def self.add_cname_record(conn, cname, dnsname)
    cn,parent = self.split_cn_parent(cname)

    # append dot if this is a FQDN
    if(dnsname.match(/\./) and dnsname[-1] != '.')
      dnsname = dnsname + "."
    end

    new_entry = [
      LDAP.mod(LDAP::LDAP_MOD_ADD,'objectclass',['dnszone','dnsrrset']),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnscname',[dnsname]),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnsdomainname',[cn]),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnstype',["CNAME"]),
      LDAP.mod(LDAP::LDAP_MOD_ADD,'dnsclass',["IN"]),
    ]
    begin
      conn.add("cn=%s,cn=%s,ou=DNS,dc=thm" % [cn,parent], new_entry)
    rescue LDAP::ResultError
    end
    conn.perror("add")
  end

  def self.delete_record(conn, dnsname)
    cn,parent = self.split_cn_parent(dnsname)
    begin
      conn.delete("cn=%s,cn=%s,ou=DNS,dc=thm" % [cn,parent])
    rescue LDAP::ResultError
    end
    conn.perror("delete")
  end

  def self.delete_reverse_record(conn,ipaddr)
    lastdigit = ipaddr.split(".")[3]
    reverse_domain = self.get_reverse_domain(ipaddr)
    begin
      conn.delete("cn=%s,cn=%s,ou=DNS,dc=thm" % [lastdigit,reverse_domain])
    rescue LDAP::ResultError
    end
    conn.perror("delete")
  end

  def self.get_reverse_domain(ipaddr) 
    ipaddr1 = IPAddr.new ipaddr
    ipaddr1.reverse.split(".")[1..-1].join(".")
  end

  def self.split_cn_parent(dnsname)
    cn = dnsname.split(".")[0]
    parent = dnsname.split(".")[1..-1].join(".")
    if( not $VALID_DOMAINS.include?(parent) )
      raise "Unknown domain: %s" % parent
    end
    return cn,parent
  end

end
  
