require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "Transactional Tests" do
  
  class Canoe
    include DataMapper::Resource
    property :id, Serial
  end
  
  before(:all) do
    puts "before all"
    Canoe.auto_migrate! unless Canoe.storage_exists?
  end
  
  before(:each) do
    puts "before..."
    Canoe.count.should == 0
    Canoe.create
    Canoe.count.should == 1
  end
  
  after(:each) do
    Canoe.create
  end
  
  describe "rollback_transaction" do

    it "should roll back the database after the test is finished (1)" do
      Canoe.count.should == 1
      Canoe.create
      Canoe.count.should == 2
    end
    
    it "should roll back the database after the test is finished (2)" do
      # rollback_transaction do
      Canoe.count.should == 1
      Canoe.create
      Canoe.count.should == 2
    end
    
    it "should roll back the database after the test is finished (3)" do
      Canoe.count.should == 1
      Canoe.create
      Canoe.count.should == 2
    end
    
  end
  
end