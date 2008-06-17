require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Integer do

  describe "english" do
    
    it "should return the English word for a number" do
      1.english.should == "one"
      30.english.should == "thirty"
    end
    
  end

end