class CobblerWorker
  attr_accessor :machine_id

  def initialize(machine_id)
    self.machine_id = machine_id
  end

  def perform
    #Load provisioning server (cobbler instance)
    target_provisioning_server = Machine.find(machine_id)
    target_name                = target_provisioning_server.fqdn
    target_location            = target_provisioning_server.location.name
    
    #Sync
    Cobbler::System.hostname  = target_name

    #Get existing systems
    Delayed::Worker.logger.info "#{Time.now}: Retrieving systems from #{target_name}"
    remote_systems            = Cobbler::System.find
    remote_system_names       = remote_systems.map(&:name)

    #Get the list of hypervisors
    Delayed::Worker.logger.info "#{Time.now}: Retrieving list of hypervisors in #{target_location} from Asset Tracker for #{target_name}"
    current_systems           = PhysicalMachine.located(target_location).acting_as_hypervisors.all(:include => :interfaces)
    current_system_names      = current_systems.map(&:fqdn)

    old_systems               = remote_system_names - current_system_names
    new_systems               = current_system_names - remote_system_names
    existing_systems          = current_system_names - new_systems

    Delayed::Worker.logger.info "#{Time.now}: Deleting old systems from #{target_name}"
    delete_old_and_existing_remote_systems(remote_systems, (old_systems+existing_systems).uniq )
    #Create new and existing systems (instead of updating existing systems, we are just deleting and creating a new system)
    Delayed::Worker.logger.info "#{Time.now}: Sending new systems to #{target_name}"
    create_new_remote_systems(current_systems,(new_systems+existing_systems).uniq)

  end

  private

  def delete_old_and_existing_remote_systems(remote_systems,systems_to_be_deleted)
    remote_systems.each do |machine|
      machine.remove if systems_to_be_deleted.include? machine.name  
    end
  end

  def create_new_remote_systems(local_systems,systems_to_be_created)
    local_systems.each do |machine|
      if systems_to_be_created.include? machine.fqdn and ! ( machine.tags.map(&:name).include? EXCLUDE_FROM_PROVISIONING_SERVER_TAG )
        profile           = "Centos5.5-x86_64"
        requested_profile = ""
        machine.tags.detect{|tag| tag.name.match(/profile:(.*)/) and requested_profile = $1.capitalize}
        profile           = requested_profile unless requested_profile.blank?
        Delayed::Worker.logger.info "#{Time.now}: Selected profile #{profile} for #{machine.fqdn}"
        system            = Cobbler::System.new('name'=> machine.fqdn,'profile'=> profile)
        #TODO add error handling, don't assume this machine has an interface
        system.hostname   = machine.fqdn
        system.gateway    = machine.main_if.gateway 
        system.interfaces = [ Cobbler::NetworkInterface.new({ 'mac_address'  => machine.main_if.mac,
                                                              'ip_address'   => machine.main_ip,
                                                              'dhcp_tag'     => machine.shortname,
                                                              'dns_name'     => machine.fqdn
                                                            })]      
        system.save
      end
    end
  end


end
