#
# distro.rb 
# 
# Copyright (C) 2008 Red Hat, Inc.
# Written by Darryl L. Pierce <dpierce@redhat.com>
#
# This file is part of rubygem-cobbler.
#
# rubygem-cobbleris free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published 
# by the Free Software Foundation, either version 2.1 of the License, or
# (at your option) any later version.
#
# rubygem-cobbler is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with rubygem-cobbler.  If not, see <http://www.gnu.org/licenses/>.
#
 
module Cobbler
  
  # +Distro+ represents a single distrobution within Cobbler.
  #
  class Distro < Base
    cobbler_lifecycle :find_all => 'get_distros',
      :find_one => 'get_distro',
      :remove => 'remove_distro'
    
    cobbler_field :name
    cobbler_collection :owners, :packing => :array
    cobbler_field :kernel
    cobbler_field :breed
    cobbler_field :depth
    cobbler_field :arch
    cobbler_field :initrd
    cobbler_field :source_repos
    cobbler_field :kernel_options
    cobbler_field :parent
    cobbler_field :ks_meta
    
    def initialize(definitions = nil)
      super(definitions)
    end
    
    private
    
    # Creates a new instance of +Profile+ from a result received from Cobbler.
    #
    def self.create(attrs)
      Distro.new(attrs)
    end
  end
end
