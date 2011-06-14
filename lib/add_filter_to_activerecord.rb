module AddFilter
    # applies list options to retrieve matching records from database
    def filter(options)
      raise(ArgumentError, "Expected Hash, got #{options.inspect}") unless options.is_a?(Hash)
      # compose all filters
      scope = self
      options.each_pair do |key, value|
        if self.filter_list.include?(key) and ! value.blank?
          scope = scope.send(key.to_sym, value) 
        end
      end
      scope # return the ActiveRecord proxy object
    end

    # returns array of valid filters (actually it returns all the named scopes, this needs some work)
    def filter_list
      @filter_names ||= self.scopes.map{|s| s.first.to_s}
    end
end

ActiveRecord::Base.send(:extend,AddFilter)
