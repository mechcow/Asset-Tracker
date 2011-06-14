module MachinesHelper

  def fields_for_interface(type,interface,&block)
    prefix = interface.new_record? ? 'new_' : ''
    fields_for("#{type}[#{prefix}interface_attributes][]", interface, &block)
  end 
  
  def get_interfaces(asset)
    interfaces = asset.interfaces.select(&:new_record?)
    interfaces << Interface.new if interfaces.empty?
    interfaces
  end

  def css_display(interfaces)
    errors_empty = interfaces.map(&:errors).reject(&:empty?).empty?
    names_empty  = interfaces.map(&:name).reject(&:blank?).empty?
    (errors_empty and names_empty) ? "none" : "inline"
  end
end
