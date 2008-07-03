require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe ModelGenerator do
  
  before(:each) do
    @file = File.join(Mack::Configuration.root, "app", "models", "zoo.rb")
    FileUtils.rm_rf(@file)
  end
  
  after(:each) do
    FileUtils.rm_rf(@file)
  end
  
  it "should require a name for the model" do
    lambda{ ModelGenerator.new }.should raise_error(ArgumentError)
  end
  
  it "should instantiate correct generator" do
    ModelGenerator.new("NAME" => "zoo").should be_instance_of(ModelGenerator)
  end
  
  it "should create a file for the model" do
    File.exists?(@file).should_not == true
    ModelGenerator.run("NAME" => "zoo")
    File.exists?(@file).should == true
    puts File.read(@file)
  end
  
  it "should create a stub test/unit test for the model if test_case is testing framework"
  
  it "should create a stub rspec test for the model if rspec is testing framework"
  
  it "should create a migration file" do
    mig_file = File.join(migrations_directory, "001_create_zoos.rb")
    File.exists?(mig_file).should_not == true
    ModelGenerator.run("NAME" => "zoo", "cols" => "name:string,description:text,created_at:date_time,updated_at:date_time")
    File.exists?(mig_file).should == true
  end
  
end