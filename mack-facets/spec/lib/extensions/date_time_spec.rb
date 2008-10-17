require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe DateTime do
  
  before(:all) do
    sec = DateTime.now.sec.to_i
    if sec == 0 || sec == 59 || DateTime.now.sec == 1
      sleep(5)
    end
  end

  describe 'add_seconds' do
    
    it "should add seconds to the DateTime object" do
      dt = DateTime.now
      dt2 = dt.add_seconds(1)
      dt2.sec.should == (dt.sec + 1)
    end
    
  end
  
  describe 'minus_seconds' do
    
    it "should minus seconds to the DateTime object" do
      dt = DateTime.now
      dt2 = dt.minus_seconds(1)
      dt2.sec.should == (dt.sec - 1)
    end
    
  end

end