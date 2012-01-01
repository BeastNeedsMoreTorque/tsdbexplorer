#
#  This file is part of TSDBExplorer.
#
#  TSDBExplorer is free software: you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by the
#  Free Software Foundation, either version 3 of the License, or (at your
#  option) any later version.
#
#  TSDBExplorer is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
#  Public License for more details.
#
#  You should have received a copy of the GNU General Public License along
#  with TSDBExplorer.  If not, see <http://www.gnu.org/licenses/>.
#
#  $Id: main_controller_spec.rb 108 2011-04-19 20:25:19Z pwh $
#

require 'spec_helper'

describe MainController do

  render_views

  it "should redirect to a setup page when called with an empty database" do
    get :index
    response.should redirect_to :action => :setup
  end

  it "should show an informational page when called with an empty database" do
    get :setup
    response.code.should eql("200")
    response.body.should =~ /You will need some CIF timetable data/
  end

  it "should show a message when the site is in to maintenance mode" do
    TSDBExplorer::Realtime::set_maintenance_mode('Test message')
    get :index
    response.code.should eql("503")
    response.body.should include('Test message')
    response.should render_template('common/maintenance_mode')
  end
                     
  it "should not show a message when the site is taken out of maintenance mode" do
    TSDBExplorer::Realtime::set_maintenance_mode('Test message')
    TSDBExplorer::Realtime::clear_maintenance_mode
    get :index
    response.code.should_not eql("503")
    response.body.should_not include('Test message')
    response.should_not render_template('common/maintenance_mode')
  end

  it "should the latest schedule date in the footer" do
    result = TSDBExplorer::CIF::process_cif_file('test/fixtures/cif/record_bs_new_fullextract.cif')
    result.status.should eql(:ok)
    get :index
    response.code.should eql("200")
    response.body.should =~ /Schedules are available for dates up to Sunday 15th May 2011/
  end

  it "should not display the latest schedule date if no CIF data has been imported" do
    get :setup
    response.code.should eql("200")
    response.body.should_not =~ /Schedules are available for dates up to/
  end

end
