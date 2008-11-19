# Copyright (c) 2008 Thiago Arrais
#
# This file is part of rODF.
#
# rODF is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.

# Foobar is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'odf/style'

describe ODF::Style do
  it "should output properties when they're added" do
    ODF::Style.create.should_not have_tag('//style:style/*')
    
    output = ODF::Style.create 'odd-row-cell', :family => :cell do |s|
      s.property :cell, 'background-color' => '#b3b3b3',
                        'border' => '0.002cm solid #000000'
      s.property :text, 'color' => '#4c4c4c'
    end

    output.should have_tag('//style:style/*', :count => 2)
    output.should have_tag('//style:table-cell-properties')
    output.should have_tag('//style:text-properties')

    cell_elem = Hpricot(output).at('style:table-cell-properties')
    cell_elem['fo:background-color'].should == '#b3b3b3'
    cell_elem['fo:border'].should == '0.002cm solid #000000'

    text_elem = Hpricot(output).at('style:text-properties')
    text_elem['fo:color'].should == '#4c4c4c'
  end
end
