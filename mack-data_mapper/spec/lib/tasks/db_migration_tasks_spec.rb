require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'
require 'migration_runner'
describe "rake" do

  describe "db" do
    
    class Zoo
      include DataMapper::Resource
      
      property :id, Serial
      property :name, String
      property :description, Text
      property :created_at, DateTime
      property :updated_at, DateTime
    end
    
    before(:each) do
      FileUtils.rm_rf(Mack::Paths.migrations)
      FileUtils.mkdir_p(Mack::Paths.migrations)
      File.open(Mack::Paths.migrations("001_create_zoos.rb"), "w") {|f| f.puts fixture("create_zoos.rb")}
      DataMapper::MigrationRunner.reset!
    end

    after(:each) do
      FileUtils.rm_rf(Mack::Paths.migrations)
      DataMapper::MigrationRunner.reset!
    end
  
    describe "migrate" do
    
      it "should migrate the database with the migrations in the db/migrations folder" do
        Zoo.should_not be_storage_exists
        DataMapper::MigrationRunner.reset!
        rake_task("db:migrate")
        Zoo.should be_storage_exists
      end
    
    end
  
    describe "rollback" do
    
      it "should rollback the database by a default of 1 step" do
        Zoo.should_not be_storage_exists
        DataMapper::MigrationRunner.reset!
        rake_task("db:migrate")
        Zoo.should be_storage_exists
        DataMapper::MigrationRunner.reset!
        rake_task("db:rollback")
        Zoo.should_not be_storage_exists
      end
    
      it "should rollback the database by n steps if ENV['STEP'] is set" do
        pending
        "".should == "asdf"
      end
    
    end
  
    describe "version" do
    
      it "should return the current version number of the database" do
        pending
        raise "asdfasdfa"
      end
    
    end
  
  end
  
end