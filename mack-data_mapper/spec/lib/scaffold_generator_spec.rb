require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe ScaffoldGenerator do
  
  before(:each) do
    @model_file = Mack::Paths.models("zoo.rb")
    @controller_file = Mack::Paths.controllers("zoos_controller.rb")
    @old_route_file = File.read(Mack::Paths.config("routes.rb"))
    common_cleanup
  end
  
  after(:each) do
    common_cleanup
  end
  
  it "should require a name for the scaffold" do
    lambda{ScaffoldGenerator.new}.should raise_error(ArgumentError)
    ScaffoldGenerator.new("NAME" => "zoo").should be_instance_of(ScaffoldGenerator)
  end
  
  it "should handle plural/singular names correctly"
  
  it "should update the routes.rb file with the resource name"
  
  it "should create a stub test/unit test for the controller if test/unit is testing framework"
  
  it "should create a stub rspec test for the controller if rspec is testing framework"
  
  it "should create a controller file" do
    File.should_not be_exist(@controller_file)
    ScaffoldGenerator.run("NAME" => "zoo")
    File.should be_exist(@controller_file)
    File.read(@controller_file).should == fixture("zoos_controller.rb")
  end
  
  it "should create the proper view files"
  
  it "should create a model file"
  
  it "should create a migration file"
  
  def common_cleanup
    FileUtils.rm_rf(@model_file)
    FileUtils.rm_rf(@controller_file)
    FileUtils.rm_rf(Mack::Paths.migrations)
    FileUtils.rm_rf(Mack::Paths.views("zoos"))
    FileUtils.rm_rf(Mack::Paths.unit)
    FileUtils.rm_rf(Mack::Paths.functional)
    File.open(Mack::Paths.config("routes.rb"), "w") {|f| f.puts @old_route_file}
  end
  
end