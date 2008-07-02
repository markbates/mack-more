require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe MigrationGenerator do
  
  before(:each) do
    @migration_file = File.join(migrations_directory, "001_create_zoos.rb")
    FileUtils.rm_rf(migrations_directory)
  end
  
  after(:each) do
    FileUtils.rm_rf(migrations_directory)
  end
  
  it "should require a name for the migration" do
    lambda{MigrationGenerator.new}.should raise_error(ArgumentError)
    MigrationGenerator.new("NAME" => "create_zoos").should be_instance_of(MigrationGenerator)
  end
  
  it "should create an empty migration file if no columns are specified" do
    File.should_not be_exist(@migration_file)
    MigrationGenerator.run("NAME" => "create_zoos")
    File.should be_exist(@migration_file)
    read_file(@migration_file).should == fixture("create_zoos_empty.rb")
  end
  
  it "should create a 'full' migration file if columns are specified"
  
  it "should name the migration file with the next available number" do
    MigrationGenerator.run("NAME" => "create_zoos")
    MigrationGenerator.run("NAME" => "create_animals")
    File.should be_exist(File.join(migrations_directory, "002_create_animals.rb"))
  end
  
end