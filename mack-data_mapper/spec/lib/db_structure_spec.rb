require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Mack::Database do
  
  class House
    include DataMapper::Resource
    
    property :id, Serial
    property :color, String
    property :address, Text, :nullable => true
  end
  
  class Cottage
    include DataMapper::Resource
    
    property :id, Serial
    property :created_at, DateTime
  end
  
  before(:each) do
    @dump = Mack::Paths.db("test_schema_structure.sql")
  end
  
  after(:each) do
    FileUtils.rm_rf(@dump)
  end
  
  def create_structure_dump_test_db(repis, path, auto_migrate = true)
    DataMapper.setup(repis, path)
    Mack::Database.drop(Mack.env, repis)
    Mack::Database.create(Mack.env, repis)
    if auto_migrate
      House.auto_migrate!(repis)
      Cottage.auto_migrate!(repis)
    end
  end
  
  describe "load_structure" do
    
    describe "MySQL" do
      
      it "should reconstructe a db from a .sql file" do
        create_structure_dump_test_db(:test_mysql, "mysql://root@localhost/structure_dump_test", false)
        Cottage.should_not be_storage_exists(:test_mysql)
        House.should_not be_storage_exists(:test_mysql)
        Mack::Database.load_structure(fixture_location("test_test_mysql_schema_structure.sql"), Mack.env, :test_mysql)
        Cottage.should be_storage_exists(:test_mysql)
        House.should be_storage_exists(:test_mysql)
      end
      
    end
    
    describe "Postgres" do
      
      it "should reconstructe a db from a .sql file" do
        create_structure_dump_test_db(:test_postgres, "postgres://ruby:password@localhost/structure_dump_test1", false)
        Cottage.should_not be_storage_exists(:test_postgres)
        House.should_not be_storage_exists(:test_postgres)
        Mack::Database.load_structure(fixture_location("test_test_postgres_schema_structure.sql"), Mack.env, :test_postgres)
        Cottage.should be_storage_exists(:test_postgres)
        House.should be_storage_exists(:test_postgres)
      end
      
    end
    
    describe "SQLite3" do
      
      it "should reconstructe a db from a .sql file" do
        create_structure_dump_test_db(:test_sqlite3, "sqlite3://#{Mack::Paths.db("structure_dump_test1.db")}", false)
        Cottage.should_not be_storage_exists(:test_sqlite3)
        House.should_not be_storage_exists(:test_sqlite3)
        Mack::Database.load_structure(fixture_location("test_test_sqlite3_schema_structure.sql"), Mack.env, :test_sqlite3)
        Cottage.should be_storage_exists(:test_sqlite3)
        House.should be_storage_exists(:test_sqlite3)
      end
      
    end
    
  end
  
  describe "dump_structure" do
  
    describe "MySQL" do
    
      it "should write a .sql that represents the db structure" do
        create_structure_dump_test_db(:test_mysql, "mysql://root@localhost/structure_dump_test")
        File.should_not be_exists(@dump)
        Mack::Database.dump_structure(Mack.env, :test_mysql)
        File.should be_exists(@dump)
        File.read(@dump).should == fixture("test_test_mysql_schema_structure.sql")
      end
    
    end
      
    describe "Postgres" do
    
      it "should write a .sql that represents the db structure" do
        create_structure_dump_test_db(:test_postgres, "postgres://ruby:password@localhost/structure_dump_test")
        File.should_not be_exists(@dump)
        Mack::Database.dump_structure(Mack.env, :test_postgres)
        File.should be_exists(@dump)
        File.read(@dump).should == fixture("test_test_postgres_schema_structure.sql")
      end
    
    end
      
    describe "SQLite3" do
    
      it "should write a .sql that represents the db structure" do
        create_structure_dump_test_db(:test_sqlite3, "sqlite3://#{Mack::Paths.db("structure_dump_test.db")}")
        File.should_not be_exists(@dump)
        Mack::Database.dump_structure(Mack.env, :test_sqlite3)
        File.should be_exists(@dump)
        File.read(@dump).should == fixture("test_test_sqlite3_schema_structure.sql")
      end
    
    end
    
  end
  
end