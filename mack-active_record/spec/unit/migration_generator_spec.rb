require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe MigrationGenerator do
  
  it "should require a name for the migration"
  
  it "should create an empty migration file if no columns are specified"
  
  it "should create a 'full' migration file if columns are specified"
  
  it "should name the migration file with the next available number"
  
end