require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe ModelGenerator do
      
  def cleanup(file)
    File.delete(file) if File.exists?(file)
  end
  
  after(:each) do
    cleanup(File.join(Mack.root, "app", "models", "zoo.rb"))
    cleanup(File.join(Mack.root, "db", "migrations", "002_create_zoos.rb"))
    cleanup(File.join(Mack.root, "test", "unit", "zoo_test.rb"))
  end
  
  it "should require a name for the model" do
    lambda{ ModelGenerator.new }.should raise_error(ArgumentError)
  end
  
  it "should instantiate correct generator" do
    ModelGenerator.new("NAME" => "zoo").should be_instance_of(ModelGenerator)
  end
  
  it "should create a file for the model" do
    file = File.join(Mack.root, "app", "models", "zoo.rb")
    File.exists?(file).should_not == true
    ModelGenerator.run("NAME" => "zoo")
    File.exists?(file).should == true
    
  end
  
  it "should create a stub test/unit test for the model if test_case is testing framework" do
    test_file = File.join(Mack.root, "test", "unit", "zoo_test.rb")    
    ModelGenerator.run("NAME" => "zoo")
    File.exists?(test_file).should == true
  end
  
  it "should create a stub rspec test for the model if rspec is testing framework" do
    temp_app_config("mack::testing_framework" => "rspec") do
      test_file = File.join(Mack.root, "test", "spec", "lib", "zoo_spec.rb")
      ModelGenerator.run("NAME" => "zoo")
      File.exists?(test_file).should == true
      File.delete(test_file)
    end
  end
  
  it "should create a migration file" do
    mig_file = File.join(migrations_directory, "002_create_zoos.rb")
    File.exists?(mig_file).should_not == true
    ModelGenerator.run("NAME" => "zoo", "cols" => "name:string,description:text,created_at:date_time,updated_at:date_time")
    File.exists?(mig_file).should == true
  end
  
end