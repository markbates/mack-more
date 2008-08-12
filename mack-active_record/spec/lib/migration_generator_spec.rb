require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe MigrationGenerator do
  include Mack::Genosaurus::Orm::Helpers
    
  before(:each) do
    @content_path = File.join(File.dirname(__FILE__), "contents")
    @mig_path = File.join(Mack.root, "db", "migrations")
    @mig_file = File.join(@mig_path, "002_create_zoos.rb")
  end
  
  after(:each) do
    File.delete(@mig_file) if File.exists?(@mig_file)
  end
  
  it "should require a name for the migration" do
    lambda{MigrationGenerator.new}.should raise_error(ArgumentError)
    MigrationGenerator.new("NAME" => "create_zoos").should be_instance_of(MigrationGenerator)
  end
  
  it "should create an empty migration file if no columns are specified" do
    MigrationGenerator.run("NAME" => "create_zoos")
    validate_content("mig_create_zoos_empty")
  end
  
  it "should create a 'full' migration file if columns are specified" do
    MigrationGenerator.run("NAME" => "create_zoos", "cols" => "name:string,description:text,created_at:date_time,updated_at:date_time")
    validate_content("mig_create_zoos_full")
  end
  
  it "should name the migration file with the next available number" do
    next_mig_file = File.join(@mig_path, "#{next_migration_number}_create_zoos.rb")
    MigrationGenerator.run("NAME" => "create_zoos")
    File.exists?(next_mig_file).should == true
  end
  
  private 
  
  def validate_content(file)
    fixture(file).should == File.read(@mig_file)
  end
  
end