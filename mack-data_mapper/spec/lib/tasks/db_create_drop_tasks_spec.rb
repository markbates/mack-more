require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe "rake" do

  describe "db" do
  
    describe "recreate" do
      
      class Zombie
        include DataMapper::Resource
        
        property :id, Serial
        property :name, String
      end
      
      describe "(MySQL)" do
        before(:all) do
          @db_yml = File.read(Mack::Paths.config("database.yml"))
          File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts fixture("mysql_database.yml")}
          DataMapper.setup(:mysql_test_tmp, "mysql://root@localhost/mysql")
        end
      
        after(:all) do
          File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts @db_yml}
          repository(:mysql_test_tmp) do |repo|
            repo.adapter.execute("DROP DATABASE IF EXISTS `mack_data_mapper_test`")
            repo.adapter.execute("DROP DATABASE IF EXISTS `mack_data_mapper_development`")
            repo.adapter.execute("DROP DATABASE IF EXISTS `mack_data_mapper_production`")
          end
          Mack::Database.establish_connection
        end
      
        it "should create a db for the current environment" do
          repository(:mysql_test_tmp) do |repo|
            repository(:mysql_test_tmp).adapter.query("show databases;").should_not include("mack_data_mapper_test")
            rake_task("db:recreate")
            repository(:mysql_test_tmp).adapter.query("show databases;").should include("mack_data_mapper_test")
          end
        end
      
        it "should drop/create a db if it already exists for the current environment" do
          rake_task("db:recreate")
          Zombie.should_not be_storage_exists
          Zombie.auto_migrate!
          Zombie.should be_storage_exist
          rake_task("db:recreate")
          Zombie.should_not be_storage_exists
        end
      
        it "should create a db for the specified environment" do
          repository(:mysql_test_tmp).adapter.query("show databases;").should_not include("mack_data_mapper_production")
          rake_task("db:recreate", "MACK_ENV" => "production")
          repository(:mysql_test_tmp).adapter.query("show databases;").should include("mack_data_mapper_production")
        end
      
        it "should drop/create a db if it already exists for the specified environment" do
          rake_task("db:recreate", "MACK_ENV" => "production")
          Zombie.should_not be_storage_exists
          Zombie.auto_migrate!
          Zombie.should be_storage_exist
          rake_task("db:recreate", "MACK_ENV" => "production")
          Zombie.should_not be_storage_exists
        end
        
      end
    
      describe "all" do
          
        before(:all) do
          @db_yml = File.read(Mack::Paths.config("database.yml"))
          File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts fixture("mysql_database.yml")}
        end
    
        after(:all) do
          File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts @db_yml}
          repository(:mysql_test_tmp) do |repo|
            repo.adapter.execute("DROP DATABASE IF EXISTS `mack_data_mapper_test`")
            repo.adapter.execute("DROP DATABASE IF EXISTS `mack_data_mapper_development`")
            repo.adapter.execute("DROP DATABASE IF EXISTS `mack_data_mapper_production`")
          end
          Mack::Database.establish_connection
        end
        
        it "should create a db for all environments" do
          repository(:mysql_test_tmp) do |repo|
            repo.adapter.query("show databases;").should_not include("mack_data_mapper_test")
            repo.adapter.query("show databases;").should_not include("mack_data_mapper_development")
            rake_task("db:recreate:all")
            repo.adapter.query("show databases;").should include("mack_data_mapper_test")
            repo.adapter.query("show databases;").should include("mack_data_mapper_development")
          end
        end
        
      end
    
    end
  
  end
  
end