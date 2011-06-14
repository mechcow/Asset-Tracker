module AddFilterToControllers

  module ClassMethods
    def managed_resource(klass)
      @managed_resource = klass
    end
    def resource
      @managed_resource
    end
  end

  def self.included(base)
    base.extend(ClassMethods)

    #TODO infer the resource automatically, this can get tricky because it has to be done in the "inherited" method and avoid using alias_method_chain
    # base.managed_resource(eval(base.name.gsub(/Controller/,'').singularize)) unless base.name =~ /ActionController/
  end


  def load_filters
    options = {}
    self.class.resource.filter_list.each do |filter_name|
      options.merge!(filter_name => params[filter_name]) unless params[filter_name].blank?
    end 
    options
  end 

end

ActionController::Base.send(:include,AddFilterToControllers)
