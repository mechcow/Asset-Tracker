#TODO Remove this if we upgrade to Rails 2.3 or greater
module AddTry
  def try(method, *args, &block)
    send(method, *args, &block) if self.class != NilClass and respond_to? method
  end
end

Object.send(:include,AddTry)
