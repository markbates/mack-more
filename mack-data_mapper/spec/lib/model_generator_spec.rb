require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe ModelGenerator do
  
  before(:each) do
    @model_file = File.join(Mack::Configuration.root, "app", "models", "zoo.rb")
    FileUtils.rm_rf(@model_file)
  end
  
  after(:each) do
    FileUtils.rm_rf(@model_file)
  end
  
  it "should require a name for the model" do
    lambda{ModelGenerator.new}.should raise_error(ArgumentError)
    ModelGenerator.new("NAME" => "zoo").should be_instance_of(ModelGenerator)
  end
  
  it "should create an empty file for the model" do
    File.should_not be_exists(@model_file)
    ModelGenerator.run("NAME" => "zoo")
    File.should be_exists(@model_file)
    read_file(@model_file).should == fixture("zoo_empty.rb")
  end
  
  it "should create a full file for the model" do
    File.should_not be_exists(@model_file)
    ModelGenerator.run("NAME" => "zoo", "cols" => "name:string,description:text,created_at:date_time,updated_at:date_time")
    File.should be_exists(@model_file)
    read_file(@model_file).should == fixture("zoo.rb")
  end
  
  it "should create a stub test/unit test for the model if test/unit is testing framework"
  
  it "should create a stub rspec test for the model if rspec is testing framework"
  
  it "should create a migration file"
  
end