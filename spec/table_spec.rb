# Copyright (c) 2008 Thiago Arrais
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

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'rodf/table'

describe RODF::Table do
  it "should allow rows to be added" do
    output = RODF::Table.create('Example') {|t| }
    output.should have_tag('//table:table')
    output.should_not have_tag('//table:table/*')

    output = RODF::Table.create('MyTable') {|t| t.row }
    output.should have_tag('//table:table/*', count: 1)
    output.should have_tag('//table:table-row')

    output = RODF::Table.create('MyTable') {|t|
      t.row
      t.row
    }
    output.should have_tag('//table:table/*', count: 2)
    output.should have_tag('//table:table-row')
  end

  it "should provide row numbers" do
    output = RODF::Table.create('Row letter table') {|t|
      t.row {|row| row.cell(row.number)}
    }
    output.should have_tag('table:table-cell')
    Hpricot(output).at('table:table-cell')['office:value-type'].should == 'float'
    Hpricot(output).at('table:table-cell')['office:value'].should == '1'
  end

  it "should allow column style specifications" do
    xml = RODF::Table.create('Styles columns table') do |t|
      t.column style: 'wide'
    end

    xml.should have_tag('table:table-column')
    column = Hpricot(xml).at('table:table-column')
    column['table:style-name'].should == 'wide'
  end

  it "should accept parameterless block" do
    output = RODF::Table.create('MyTable') {
      row
      row
    }
    output.should have_tag('//table:table/*', count: 2)
    output.should have_tag('//table:table-row')
  end

  it "should have children that accept parameterless blocks too" do
    output = RODF::Table.create('MyTable') {
      row {cell}
      row
    }
    output.should have_tag('//table:table/*', count: 2)
    output.should have_tag('//table:table-row')
    output.should have_tag('//table:table-cell')
  end

  it "should have allow row styles" do
    output = RODF::Table.create('MyTable') do
      row style: :bold do
        cell
      end
      row style: :underline do
        cell
      end
    end
    output.should include('table:table-row table:style-name="bold"')
    output.should include('table:table-row table:style-name="underline"')
  end
end
