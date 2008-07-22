require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe NilClass do
  
  describe "to_param" do
    
    it "should raise NoMethodError" do
      lambda{nil.to_param}.should raise_error(NoMethodError)
    end
    
  end
  
end