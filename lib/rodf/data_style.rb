# Copyright (c) 2010 Thiago Arrais
#
# This file is part of rODF.
#
# rODF is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.

# rODF is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with rODF.  If not, see <http://www.gnu.org/licenses/>.

require 'builder'

require 'rodf/container'
require 'rodf/style_section'

module RODF
  class DataStyle < Container
    contains :style_sections

    alias section style_section

    def initialize(name, type)
      @type, @name = type, name
    end

    def xml
      Builder::XmlMarkup.new.tag! "number:#{@type}-style", 'style:name' => @name do |xml|
        xml << style_sections_xml
      end
    end

    def method_missing(name, *args)
      section(name, *args)
    end
  end
end
