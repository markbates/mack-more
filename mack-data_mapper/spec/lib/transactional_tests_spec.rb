require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "Transactional Tests" do
  
  describe "rollback_transaction" do

    class Canoe
      include DataMapper::Resource
      property :id, Serial
    end
    Canoe.auto_migrate!
    
    it "should roll back the database after the test is finished (1)" do
      Canoe.count.should == 0
      Canoe.create
      Canoe.count.should == 1
    end
    
    it "should roll back the database after the test is finished (2)" do
      Canoe.count.should == 0
      Canoe.create
      Canoe.count.should == 1
    end
    
    it "should roll back the database after the test is finished (3)" do
      Canoe.count.should == 0
      Canoe.create
      Canoe.count.should == 1
    end
    
  end
  
end