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
    @mysql_dump = File.join(Mack.root, "db", "test_test_mysql_schema_structure.sql")
    @postgres_dump = File.join(Mack.root, "db", "test_test_postgres_schema_structure.sql")
    @sqlite3_dump = File.join(Mack.root, "db", "test_test_sqlite3_schema_structure.sql")
  end
  
  after(:each) do
    FileUtils.rm_rf(@mysql_dump)
    FileUtils.rm_rf(@postgres_dump)
    FileUtils.rm_rf(@sqlite3_dump)
  end
  
  def create_structure_dump_test_db(repis, path)
    DataMapper.setup(repis, path)
    Mack::Database.drop(Mack.env, repis)
    Mack::Database.create(Mack.env, repis)
    House.auto_migrate!(repis)
    Cottage.auto_migrate!(repis)
  end
  
  describe "structure_dump" do
  
    describe "MySQL" do
    
      it "should write a .sql that represents the db structure" do
        create_structure_dump_test_db(:test_mysql, "mysql://root@localhost/structure_dump_test")
        
        File.should_not be_exists(@mysql_dump)
        Mack::Database.structure_dump(Mack.env, :test_mysql)
        File.should be_exists(@mysql_dump)
        File.read(@mysql_dump).should == fixture("test_test_mysql_schema_structure.sql")
      end
    
    end
  
    describe "Postgres" do
    
      it "should write a .sql that represents the db structure" do
        create_structure_dump_test_db(:test_postgres, "postgres://ruby:password@localhost/structure_dump_test")
        
        File.should_not be_exists(@postgres_dump)
        Mack::Database.structure_dump(Mack.env, :test_postgres)
        File.should be_exists(@postgres_dump)
        File.read(@postgres_dump).should == fixture("test_test_postgres_schema_structure.sql")
      end
    
    end
  
    describe "SQLite3" do
    
      it "should write a .sql that represents the db structure" do
        create_structure_dump_test_db(:test_sqlite3, "sqlite3://#{File.join(Mack.root, "db", "structure_dump_test.db")}")
        
        File.should_not be_exists(@sqlite3_dump)
        Mack::Database.structure_dump(Mack.env, :test_sqlite3)
        File.should be_exists(@sqlite3_dump)
        File.read(@sqlite3_dump).should == fixture("test_test_sqlite3_schema_structure.sql")
      end
    
    end
    
  end
  
end