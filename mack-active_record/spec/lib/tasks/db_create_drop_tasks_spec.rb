require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe "rake" do

  describe "db" do

    describe "create" do

      describe "MySQL" do
        include Spec::CreateAndDropTask::Helper::MySQL
        
        before(:each) do
          ENV["MACK_ENV"] = "development"
          clear_connection
        end
        
        after(:all) do 
          cleanup_db
        end
        
        it "should create a MySQL db for the current environment" do
          config_db(:mysql) do
            rake_task("db:recreate")
            db_exists?("foo_development").should == true
          end
        end
        
        it "should drop/create a MySQL db if it already exists for the current environment" do
          config_db(:mysql) do
            rake_task("db:recreate")
            db_exists?("foo_development").should == true
            rake_task("db:drop")
            db_exists?("foo_development").should == false
          end
        end
        
        it "should create a MySQL db for the specified environment" do
          config_db(:mysql) do
            rake_task("db:recreate", {"MACK_ENV" => "test"})
            db_exists?("foo_test").should == true
          end
        end
        
        it "should drop/create a MySQL db if it already exists for the specified environment" do
          config_db(:mysql) do
            rake_task("db:recreate", {"MACK_ENV" => "test"})
            db_exists?("foo_test").should == true
            rake_task("db:recreate", {"MACK_ENV" => "test"})
            db_exists?("foo_test").should == true
          end
        end
      end

      describe "PostgreSQL" do
        include Spec::CreateAndDropTask::Helper::PostgreSQL
        
        before(:each) do 
          clear_connection
        end
      
        after(:each) do
          cleanup_db
        end
      
        it "should create a PostgreSQL db for the current environment" do
          config_db(:postgresql) do
            rake_task("db:recreate")
            db_exists?("foo_development").should == true
          end
        end
        
        it "should drop a PostgreSQL db for the current environment" do
          config_db(:postgresql) do
            rake_task("db:recreate")
            db_exists?("foo_development").should == true
            rake_task("db:drop")
            db_exists?("foo_development").should == false
          end
        end
      
        it "should create a PostgreSQL db for the specified environment" do
          config_db(:postgresql) do
            rake_task("db:recreate", {"MACK_ENV" => "test"})
            db_exists?("foo_test", "test").should == true
          end
        end
        
        it "should drop a PostgreSQL db for the specified environment" do
          config_db(:postgresql) do
            rake_task("db:recreate", {"MACK_ENV" => "test"})
            db_exists?("foo_test", "test").should == true
            rake_task("db:drop", {"MACK_ENV" => "test"})
            db_exists?("foo_test", "test").should == false
          end
        end
      end

    end

    describe "create:all" do
    
      describe "MySQL" do
        include Spec::CreateAndDropTask::Helper::MySQL
        
        before(:all) do
          clear_connection
        end
        
        after(:all) do
          cleanup_db
        end
        
        it "should create a MySQL db for all environments" do
          config_db(:mysql) do
            rake_task("db:recreate:all")
            db_exists?("foo_development").should == true
            db_exists?("foo_test").should == true
          end
        end
        
      end
    
      describe "PostgreSQL" do
        include Spec::CreateAndDropTask::Helper::PostgreSQL
        
        before(:each) do
          clear_connection
        end
        
        after(:each) do
          cleanup_db
        end
        
        it "should create a PostgreSQL db for all environments" do
          config_db(:postgresql) do
            rake_task("db:recreate:all")
            db_exists?("foo_test", "test").should == true
            db_exists?("foo_development").should == true
            
            # running db:recreate again should be successful
            rake_task("db:recreate:all")
            db_exists?("foo_test", "test").should == true
            db_exists?("foo_development").should == true
          end
        end
        
        it "should drop a PostgreSQL db for all environments" do
          config_db(:postgresql) do
            rake_task("db:recreate:all")
            db_exists?("foo_test", "test").should == true
            db_exists?("foo_development").should == true
            rake_task("db:drop:all")
            db_exists?("foo_test", "test").should == false
            db_exists?("foo_development").should == false
          end
        end
        
      end
    end

  end

end