require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Mack::Database do
  
  class Zombie
    include DataMapper::Resource
    
    property :id, Serial
    property :name, String
  end
  
  describe "MySQL" do
    
    before(:all) do
      @db_yml = File.read(Mack::Paths.config("database.yml"))
      File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts fixture("mysql_database.yml")}
      DataMapper.setup(:mysql_test_tmp, "mysql://root@localhost/mysql")
    end
    
    after(:all) do
      File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts @db_yml}
      repository(:mysql_test_tmp) do |repo|
        repo.adapter.execute("DROP DATABASE IF EXISTS `mack_data_mapper2_test`")
        repo.adapter.execute("DROP DATABASE IF EXISTS `mack_data_mapper2_development`")
        repo.adapter.execute("DROP DATABASE IF EXISTS `mack_data_mapper2_production`")
      end
      Mack::Database.establish_connection
    end
    
    describe "create" do
      
      it "should create a db for the current environment" do
        repository(:mysql_test_tmp).adapter.query("show databases;").should_not include("mack_data_mapper2_test")
        Mack::Database.create
        repository(:mysql_test_tmp).adapter.query("show databases;").should include("mack_data_mapper2_test")
      end
      
      it "should create a db for the specified environment" do
        repository(:mysql_test_tmp).adapter.query("show databases;").should_not include("mack_data_mapper2_production")
        Mack::Database.create("production", :default)
        repository(:mysql_test_tmp).adapter.query("show databases;").should include("mack_data_mapper2_production")
      end
      
    end
    
    describe "drop" do
      
      it "should drop the db for the current environment" do
        Mack::Database.create
        Zombie.should_not be_storage_exists
        Zombie.auto_migrate!
        Zombie.should be_storage_exist
        Mack::Database.drop
        Zombie.should_not be_storage_exists
      end

      it "should drop the db for the specified environment" do
        ENV["MACK_ENV"] = "production"
        Mack::Database.create("production")
        Zombie.should_not be_storage_exists
        Zombie.auto_migrate!
        Zombie.should be_storage_exist
        Mack::Database.drop("production")
        Zombie.should_not be_storage_exists
        ENV["MACK_ENV"] = "test"
      end
      
    end
    
  end

end