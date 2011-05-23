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
#  $Id$
#

require 'spec_helper'

describe BasicSchedule do

  before(:each) do
    @valid_record = { :train_uid => 'A00000', :status => 'P', :run_date => '2011-01-01', :category => 'OO', :train_identity => '2A00', :headcode => '0000', :service_code => '00000000', :portion_id => '0', :power_type => 'EMU', :timing_load => '321', :speed => '100', :operating_characteristics => 'C', :train_class => 'B', :sleepers => 'B', :reservations => 'S', :connection_indicator => 'X', :catering_code => 'T', :service_branding => 'E'}
  end

  it "should be valid with all required fields" do

    basic_schedule = BasicSchedule.new(@valid_record)
    basic_schedule.should be_valid

  end

  it "should enforce the format of a Train UID" do

    [ 'A00000', 'Z99999' ].each do |train_uid|
      @valid_record[:train_uid] = train_uid
      BasicSchedule.new(@valid_record).should be_valid
    end

    [ nil, '', '123456', 'AAAAAA', 'A1' ].each do |train_uid|
      @valid_record[:train_uid] = train_uid
      BasicSchedule.new(@valid_record).should_not be_valid
    end

  end

  it "should enforce certain status values" do

    [ 'B', 'F', 'P', 'S', 'T', '1', '2', '3', '4', '5' ].each do |status_value|
      @valid_record[:status] = status_value
      BasicSchedule.new(@valid_record).should be_valid
    end

    [ nil, '', 'A', '0'].each do |status_value|
      @valid_record[:status] = status_value
      BasicSchedule.new(@valid_record).should_not be_valid
    end

  end

  it "should enforce the format of a Train Identity" do

    [ '0A00', '1Z99', '2W00', '5H55', '9O99' ].each do |train_identity|
      @valid_record[:train_identity] = train_identity
      BasicSchedule.new(@valid_record).should be_valid
    end

    [ nil, '', '0000', 'AAAA', '0A', '0AZZ' ].each do |train_identity|
      @valid_record[:train_identity] = train_identity
      BasicSchedule.new(@valid_record).should_not be_valid
    end

  end

  it "should enforce the format of a Headcode" do

    [ nil, '', '    ', '0000', '9999' ].each do |headcode|
      @valid_record[:headcode] = headcode
      BasicSchedule.new(@valid_record).should be_valid
    end

    [ '0', 'AAAAA' ].each do |headcode|
      @valid_record[:headcode] = headcode
      BasicSchedule.new(@valid_record).should_not be_valid
    end

  end

  it "should enforce the format of a Service Code" do

    [ nil, '', '    ', '00000000', '99999999' ].each do |service_code|
      @valid_record[:service_code] = service_code
      BasicSchedule.new(@valid_record).should be_valid
    end

    [ '0', 'AAAAAAAA' ].each do |service_code|
      @valid_record[:service_code] = service_code
      BasicSchedule.new(@valid_record).should_not be_valid
    end

  end

  it "should enforce the format of a Portion ID" do

    [ nil, '', ' ', '0', '1', '2', '4', '8', 'Z' ].each do |service_code|
      @valid_record[:portion_id] = service_code
      BasicSchedule.new(@valid_record).should be_valid
    end

    [ '3', 'A' ].each do |service_code|
      @valid_record[:portion_id] = service_code
      BasicSchedule.new(@valid_record).should_not be_valid
    end

  end

  it "should enforce a numeric speed" do

    [ nil, '', ' ', '10', '100', '125', '140' ].each do |speed|
      @valid_record[:speed] = speed
      BasicSchedule.new(@valid_record).should be_valid
    end

    [ 'A' ].each do |speed|
      @valid_record[:speed] = speed
      BasicSchedule.new(@valid_record).should_not be_valid
    end

  end

  it "should enforce the format of the Operating Characteristics" do

    [ nil, '', ' ', 'B', 'C', 'D', 'E', 'G', 'M', 'P', 'Q', 'R', 'S', 'Y', 'Z' ].each do |operating_characteristics|
      @valid_record[:operating_characteristics] = operating_characteristics
      BasicSchedule.new(@valid_record).should be_valid
    end

    [ 'A', '3' ].each do |operating_characteristics|
      @valid_record[:operating_characteristics] = operating_characteristics
      BasicSchedule.new(@valid_record).should_not be_valid
    end

  end

  it "should require a valid Train Class" do

    [ nil, ' ', 'B', 'S' ].each do |train_class|
      @valid_record[:train_class] = train_class
      BasicSchedule.new(@valid_record).should be_valid
    end

    [ 'A', '3' ].each do |train_class|
      @valid_record[:train_class] = train_class
      BasicSchedule.new(@valid_record).should_not be_valid
    end

  end

  it "should require a valid Sleeper Type" do

    [ ' ', 'B', 'F', 'S' ].each do |sleepers|
      @valid_record[:sleepers] = sleepers
      BasicSchedule.new(@valid_record).should be_valid
    end

    [ 'A', '3' ].each do |sleepers|
      @valid_record[:sleepers] = sleepers
      BasicSchedule.new(@valid_record).should_not be_valid
    end

  end

  it "should require a valid Reservation status" do

    [ nil, ' ', 'A', 'E', 'R', 'S' ].each do |reservations|
      @valid_record[:reservations] = reservations
      BasicSchedule.new(@valid_record).should be_valid
    end

    [ 'Z', '3' ].each do |reservations|
      @valid_record[:reservations] = reservations
      BasicSchedule.new(@valid_record).should_not be_valid
    end

  end

  it "should require a valid Connection Indicator" do

    [ nil, ' ', 'C', 'S', 'X' ].each do |connection_indicator|
      @valid_record[:connection_indicator] = connection_indicator
      BasicSchedule.new(@valid_record).should be_valid
    end

    [ 'Z', '3' ].each do |connection_indicator|
      @valid_record[:connection_indicator] = connection_indicator
      BasicSchedule.new(@valid_record).should_not be_valid
    end

  end

  it "should require a valid Catering Code" do

    [ nil, '  ', 'C', 'F', 'H', 'M', 'P', 'R', 'T', 'CM', 'CF', 'MT' ].each do |catering_code|
      @valid_record[:catering_code] = catering_code
      BasicSchedule.new(@valid_record).should be_valid
    end

#    [ 'Z', '3' ].each do |catering_code|
#      @valid_record[:catering_code] = catering_code
#      BasicSchedule.new(@valid_record).should_not be_valid
#    end

  end

  it "should require a valid Service Branding" do

    [ nil, ' ', 'E', 'U' ].each do |service_branding|
      @valid_record[:service_branding] = service_branding
      BasicSchedule.new(@valid_record).should be_valid
    end

    [ 'Z', '3' ].each do |service_branding|
      @valid_record[:service_branding] = service_branding
      BasicSchedule.new(@valid_record).should_not be_valid
    end

  end

end