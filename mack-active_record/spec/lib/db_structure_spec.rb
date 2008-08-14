require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Mack::Database do
  
  class House < ActiveRecord::Base
    # include DataMapper::Resource
    # 
    # property :id, Serial
    # property :color, String
    # property :address, Text, :nullable => true
  end
  
  class Cottage < ActiveRecord::Base
    # include DataMapper::Resource
    # 
    # property :id, Serial
    # property :created_at, DateTime
  end
  
  class HouseMigration < ActiveRecord::Migration
    def self.up
      create_table :houses do |t|
        t.column :color, :string
        t.column :address, :text
      end
    end
    def self.down
      drop_table :houses
    end
  end
  
  class CottageMigration < ActiveRecord::Migration
    def self.up
      create_table :cottages do |t|
      end
    end
    def self.down
      drop_table :cottages
    end
  end
  
  before(:each) do
    @dump = File.join(Mack.root, "db", "#{Mack.env}_schema_structure.sql")
  end
  
  after(:each) do
    FileUtils.rm_rf(@dump)
  end
  
  describe "load_structure" do
    
    describe "MySQL" do
      include Spec::CreateAndDropTask::Helper::MySQL
      
      it "should reconstructe a db from a .sql file" do
        config_db(:mysql) do
          Mack::Database.recreate
          Mack::Database.establish_connection(Mack.env)
          House.should_not be_table_exists
          Cottage.should_not be_table_exists
          Mack::Database.load_structure(fixture_location("mysql_schema_structure.sql"), "test")
          House.should be_table_exists
          Cottage.should be_table_exists
        end
      end
      
    end
    
    describe "Postgres" do
      include Spec::CreateAndDropTask::Helper::PostgreSQL
      
      it "should reconstructe a db from a .sql file" do
        config_db(:postgresql) do
          Mack::Database.recreate("development")
          Mack::Database.recreate("test")
          Mack::Database.establish_connection(Mack.env)
          House.should_not be_table_exists
          Cottage.should_not be_table_exists
          Mack::Database.load_structure(fixture_location("postgres_schema_structure.sql"), "test")
          House.should be_table_exists
          Cottage.should be_table_exists
        end
      end
      
    end
    
    describe "SQLite3" do
      
      it "should reconstructe a db from a .sql file" do
        Mack::Database.recreate("development")
        Mack::Database.recreate("test")
        Mack::Database.establish_connection(Mack.env)
        House.should_not be_table_exists
        Cottage.should_not be_table_exists
        Mack::Database.load_structure(fixture_location("sqlite3_schema_structure.sql"), "test")
        House.should be_table_exists
        Cottage.should be_table_exists
      end
      
    end
    
  end
  
  describe "dump_structure" do
  
    describe "MySQL" do
      include Spec::CreateAndDropTask::Helper::MySQL
            
      it "should write a .sql that represents the db structure" do
        config_db(:mysql) do
          Mack::Database.recreate
          Mack::Database.establish_connection(Mack.env)
          HouseMigration.up
          CottageMigration.up
          File.should_not be_exists(@dump)
          Mack::Database.dump_structure(Mack.env)
          File.should be_exists(@dump)
          File.read(@dump).should == fixture("mysql_schema_structure.sql")
        end
      end
    
    end
      
    describe "Postgres" do
      include Spec::CreateAndDropTask::Helper::PostgreSQL
      
      it "should write a .sql that represents the db structure" do
        config_db(:postgresql) do
          Mack::Database.recreate
          Mack::Database.establish_connection(Mack.env)
          HouseMigration.up
          CottageMigration.up
          File.should_not be_exists(@dump)
          Mack::Database.dump_structure(Mack.env)
          File.should be_exists(@dump)
          File.read(@dump).should == fixture("postgres_schema_structure.sql")
        end
      end
    
    end
      
    describe "SQLite3" do
    
      it "should write a .sql that represents the db structure" do
        Mack::Database.recreate
        Mack::Database.establish_connection(Mack.env)
        HouseMigration.up
        CottageMigration.up
        File.should_not be_exists(@dump)
        Mack::Database.dump_structure(Mack.env)
        File.should be_exists(@dump)
        File.read(@dump).should == fixture("sqlite3_schema_structure.sql")
      end
    
    end
    
  end
  
end