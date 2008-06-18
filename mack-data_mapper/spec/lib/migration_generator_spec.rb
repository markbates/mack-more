require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe MigrationGenerator do
  
  it "should require a name for the migration" do
    lambda{MigrationGenerator.new}.should raise_error(ArgumentError)
    MigrationGenerator.new("NAME" => "foo").should be_instance_of(MigrationGenerator)
  end
  
  it "should create an empty migration file if no columns are specified"
  
  it "should create a 'full' migration file if columns are specified"
  
  it "should name the migration file with the next available number"
  
end