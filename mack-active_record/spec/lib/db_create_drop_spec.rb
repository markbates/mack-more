require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Mack::Database do
  
  describe "create" do

    describe "MySQL" do
      include Spec::CreateAndDropTask::Helper::MySQL
      
      before(:each) do
        ENV["MACK_ENV"] = "development"
        clear_connection
      end
      
      after(:each) do
        ENV["MACK_ENV"]  = "test"
      end
      
      after(:all) do 
        cleanup_db
      end
      
      it "should create a MySQL db for the current environment" do
        config_db(:mysql) do
          Mack::Database.recreate
          db_exists?("foo_development").should == true
        end
      end
      
      it "should drop/create a MySQL db if it already exists for the current environment" do
        config_db(:mysql) do
          Mack::Database.recreate
          db_exists?("foo_development").should == true
          Mack::Database.drop
          db_exists?("foo_development").should == false
        end
      end
      
      it "should create a MySQL db for the specified environment" do
        config_db(:mysql) do
          Mack::Database.recreate("test")
          db_exists?("foo_test").should == true
        end
      end
      
      it "should drop/create a MySQL db if it already exists for the specified environment" do
        config_db(:mysql) do
          Mack::Database.recreate("test")
          db_exists?("foo_test").should == true
          Mack::Database.recreate("test")
          db_exists?("foo_test").should == true
        end
      end
    end

    # describe "PostgreSQL" do
    #   include Spec::CreateAndDropTask::Helper::PostgreSQL
    #   
    #   before(:each) do 
    #     clear_connection
    #   end
    # 
    #   after(:each) do
    #     cleanup_db
    #   end
    # 
    #   it "should create a PostgreSQL db for the current environment" do
    #     config_db(:postgresql) do
    #       Mack::Database.recreate
    #       db_exists?("foo_development").should == true
    #     end
    #   end
    #   
    #   it "should drop a PostgreSQL db for the current environment" do
    #     config_db(:postgresql) do
    #       Mack::Database.recreate
    #       db_exists?("foo_development").should == true
    #       Mack::Database.drop
    #       db_exists?("foo_development").should == false
    #     end
    #   end
    # 
    #   it "should create a PostgreSQL db for the specified environment" do
    #     config_db(:postgresql) do
    #       Mack::Database.recreate("test")
    #       db_exists?("foo_test", "test").should == true
    #     end
    #   end
    #   
    #   it "should drop a PostgreSQL db for the specified environment" do
    #     config_db(:postgresql) do
    #       Mack::Database.recreate("test")
    #       db_exists?("foo_test", "test").should == true
    #       Mack::Database.drop("test")
    #       db_exists?("foo_test", "test").should == false
    #     end
    #   end
    # end

  end

end