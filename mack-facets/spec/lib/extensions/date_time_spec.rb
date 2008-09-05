require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe DateTime do

  describe 'add_seconds' do
    
    it "should add seconds to the DateTime object" do
      dt = DateTime.now
      dt2 = dt.add_seconds(10)
      dt2.sec.should == (dt.sec + 10)
    end
    
  end
  
  describe 'minus_seconds' do
    
    it "should minus seconds to the DateTime object" do
      dt = DateTime.now
      dt2 = dt.minus_seconds(10)
      dt2.sec.should == (dt.sec - 10)
    end
    
  end

end