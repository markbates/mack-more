require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe MigrationGenerator do
  
  before(:each) do
    @migration_file = Mack::Paths.migrations("001_create_zoos.rb")
    FileUtils.rm_rf(Mack::Paths.migrations)
  end
  
  after(:each) do
    FileUtils.rm_rf(Mack::Paths.migrations)
  end
  
  it "should require a name for the migration" do
    lambda{MigrationGenerator.new}.should raise_error(ArgumentError)
    MigrationGenerator.new("NAME" => "create_zoos").should be_instance_of(MigrationGenerator)
  end
  
  it "should create an empty migration file if no columns are specified" do
    File.should_not be_exist(@migration_file)
    MigrationGenerator.run("NAME" => "create_zoos")
    File.should be_exist(@migration_file)
    File.read(@migration_file).should == fixture("create_zoos_empty.rb")
  end
  
  it "should create a 'full' migration file if columns are specified" do
    MigrationGenerator.run(zoo_options.merge("name" => "create_zoos"))
    File.read(@migration_file).should == fixture("create_zoos.rb")
  end
  
  it "should name the migration file with the next available number" do
    MigrationGenerator.run("NAME" => "create_zoos")
    MigrationGenerator.run("NAME" => "create_animals")
    File.should be_exist(Mack::Paths.migrations("002_create_animals.rb"))
  end
  
  def zoo_options
    {"name" => "zoo", "cols" => "name:string,description:text,password:string,birth_date:date,member_since:date_time,created_at:date_time,updated_at:date_time"}
  end
  
end