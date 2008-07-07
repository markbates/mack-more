require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe ModelGenerator do
        
  before(:each) do 
    @model_file = File.join(Mack.root, "app", "models", "zoo.rb")
    @mig_file   = File.join(Mack.root, "db", "migrations", "002_create_zoos.rb")
    @test_file  = File.join(Mack.root, "test", "unit", "zoo_test.rb")
  end
  
  after(:each) do
    cleanup(@model_file)
    cleanup(@mig_file)
    cleanup(@test_file)
  end
  
  it "should require a name for the model" do
    lambda{ ModelGenerator.new }.should raise_error(ArgumentError)
  end
  
  it "should instantiate correct generator" do
    ModelGenerator.new("NAME" => "zoo").should be_instance_of(ModelGenerator)
  end
  
  it "should create a file for the model" do
    File.exists?(@model_file).should_not == true
    ModelGenerator.run("NAME" => "zoo")
    File.exists?(@model_file).should == true
    
  end
  
  it "should create a stub test/unit test for the model if test_case is testing framework" do
    ModelGenerator.run("NAME" => "zoo")
    File.exists?(@test_file).should == true
  end
  
  it "should create a stub rspec test for the model if rspec is testing framework" do
    temp_app_config("mack::testing_framework" => "rspec") do
      @test_file = File.join(Mack.root, "test", "unit", "zoo_spec.rb")
      ModelGenerator.run("NAME" => "zoo")
      File.exists?(@test_file).should == true
    end
  end
  
  it "should create a migration file" do
    File.exists?(@mig_file).should_not == true
    ModelGenerator.run("NAME" => "zoo", "cols" => "name:string,description:text,created_at:date_time,updated_at:date_time")
    File.exists?(@mig_file).should == true
  end
  
end