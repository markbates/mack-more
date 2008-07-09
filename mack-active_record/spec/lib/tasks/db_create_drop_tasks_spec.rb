require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe "rake" do

  describe "db" do
  
    describe "create" do
      
      describe "MySQL" do
        it "should create a MySQL db for the current environment"
        it "should drop/create a MySQL db if it already exists for the current environment"
        it "should create a MySQL db for the specified environment"
        it "should create a MySQL db for the specified environment"
        it "should drop/create a MySQL db if it already exists for the specified environment"
      end
      
      describe "PostgreSQL" do
        
        # after(:all) do
        #   config_db(:postgresql) do
        #     begin
        #       rake_task("db:drop:all")
        #     rescue => ex
        #     end
        #   end
        # end
        
        before(:each) do 
          ActiveRecord::Base.clear_active_connections!
        end
        
        it "should create a PostgreSQL db for the current environment" do
          config_db(:postgresql) do
            rake_task("db:create")
            db_exists?("foo_development").should == true
          end
        end
        
        it "should drop/create a PostgreSQL db if it already exists for the current environment"
              
        it "should create a PostgreSQL db for the specified environment" do
          config_db(:postgresql) do
            rake_task("db:create", {"MACK_ENV" => "test"})
            db_exists?("foo_test", "test").should == true
          end
        end
        
        it "should drop/create a PostgreSQL db if it already exists for the specified environment"
        
        private
        def db_exists?(name, env = "development")
          ENV["MACK_ENV"] = env
          Mack::Database.establish_connection(env)
          pg_result = ActiveRecord::Base.connection.execute "select datname from pg_database"
          pg_result.result.flatten.include?(name)
        end
      end
      
    end
    
    describe "create:all" do
    
      describe "MySQL" do
        it "should create a MySQL db for all environments"
        it "should drop/create a MySQL db all environments"
      end
      
      describe "PostgreSQL" do
        it "should create a PostgreSQL db for all environments"
        it "should drop/create a PostgreSQL db all environments"
      end
    end
  
  end
  
end