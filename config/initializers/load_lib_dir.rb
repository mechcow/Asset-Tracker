#http://www.spacevatican.org/2008/11/21/environment-rb-and-requiring-dependencies
Dir.glob( "#{ RAILS_ROOT }/lib/*.rb" ).each { |f| require f }
