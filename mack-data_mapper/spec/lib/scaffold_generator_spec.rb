require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe ScaffoldGenerator do
  
  before(:each) do
    @model_file = Mack::Paths.models("zoo.rb")
    @controller_helper_file = Mack::Paths.controller_helpers("zoos_controller_helper.rb")
    @controller_file = Mack::Paths.controllers("zoos_controller.rb")
    @old_route_file = File.read(Mack::Paths.config("routes.rb"))
    common_cleanup
  end
  
  after(:each) do
    common_cleanup
  end
  
  it "should require a name for the scaffold" do
    lambda{ScaffoldGenerator.new}.should raise_error(ArgumentError)
    ScaffoldGenerator.new(zoo_options).should be_instance_of(ScaffoldGenerator)
  end
  
  it "should update the routes.rb file with the resource name" do
    File.read(Mack::Paths.config("routes.rb")).should_not match(/r\.resource :zoos/)
    ScaffoldGenerator.run(zoo_options)
    File.read(Mack::Paths.config("routes.rb")).should match(/r\.resource :zoos/)
  end
  
  it "should create a stub test/unit test for the controller if test/unit is testing framework" do
    temp_app_config("mack::testing_framework" => "test_case") do
      File.should_not be_exist(Mack::Paths.controller_tests("zoos_controller_test.rb"))
      File.should_not be_exist(Mack::Paths.controller_helper_tests("zoos_controller_helper_test.rb"))
      ScaffoldGenerator.run(zoo_options)
      File.should be_exist(Mack::Paths.controller_tests("zoos_controller_test.rb"))
      File.should be_exist(Mack::Paths.controller_helper_tests("zoos_controller_helper_test.rb"))
      File.read(Mack::Paths.controller_tests("zoos_controller_test.rb")).should == fixture("zoos_controller_test.rb")
      File.read(Mack::Paths.controller_helper_tests("zoos_controller_helper_test.rb")).should == fixture("zoos_controller_helper_test.rb")
    end
  end
  
  it "should create a stub rspec test for the controller if rspec is testing framework" do
    temp_app_config("mack::testing_framework" => "rspec") do
      File.should_not be_exist(Mack::Paths.controller_tests("zoos_controller_spec.rb"))
      File.should_not be_exist(Mack::Paths.controller_helper_tests("zoos_controller_helper_spec.rb"))
      ScaffoldGenerator.run(zoo_options)
      File.should be_exist(Mack::Paths.controller_tests("zoos_controller_spec.rb"))
      File.should be_exist(Mack::Paths.controller_helper_tests("zoos_controller_helper_spec.rb"))
      File.read(Mack::Paths.controller_tests("zoos_controller_spec.rb")).should == fixture("zoos_controller_spec.rb")
      File.read(Mack::Paths.controller_helper_tests("zoos_controller_helper_spec.rb")).should == fixture("zoos_controller_helper_spec.rb")
    end
  end
  
  it "should create a controller file" do
    File.should_not be_exist(@controller_file)
    ScaffoldGenerator.run(zoo_options)
    File.should be_exist(@controller_file)
    File.read(@controller_file).should == fixture("zoos_controller.rb")
  end
  
  it "should create a controller helper file" do
    File.should_not be_exist(@controller_helper_file)
    ScaffoldGenerator.run(zoo_options)
    File.should be_exist(@controller_helper_file)
    File.read(@controller_helper_file).should == fixture("zoos_controller_helper.rb")
  end
  
  it "should create the proper view files" do
    File.should_not be_exist(Mack::Paths.views("zoos"))
    ScaffoldGenerator.run(zoo_options)
    File.should be_exist(Mack::Paths.views("zoos"))
    File.should be_exist(Mack::Paths.views("zoos", "edit.html.erb"))
    File.read(Mack::Paths.views("zoos", "edit.html.erb")).should == fixture("zoo_edit.html.erb")
    File.should be_exist(Mack::Paths.views("zoos", "index.html.erb"))
    File.read(Mack::Paths.views("zoos", "index.html.erb")).should == fixture("zoo_index.html.erb")
    File.should be_exist(Mack::Paths.views("zoos", "new.html.erb"))
    File.read(Mack::Paths.views("zoos", "new.html.erb")).should == fixture("zoo_new.html.erb")
    File.should be_exist(Mack::Paths.views("zoos", "show.html.erb"))
    File.read(Mack::Paths.views("zoos", "show.html.erb")).should == fixture("zoo_show.html.erb")
  end
  
  it "should create a model file" do
    File.should_not be_exist(@model_file)
    ScaffoldGenerator.run(zoo_options)
    File.should be_exist(@model_file)
    File.read(@model_file).should == fixture("zoo.rb")
  end
  
  it "should create a migration file" do
    File.should_not be_exist(Mack::Paths.migrations("001_create_zoos.rb"))
    ScaffoldGenerator.run(zoo_options)
    File.should be_exist(Mack::Paths.migrations("001_create_zoos.rb"))
    File.read(Mack::Paths.migrations("001_create_zoos.rb")).should == fixture("create_zoos.rb")
  end
  
  def common_cleanup
    FileUtils.rm_rf(@model_file)
    FileUtils.rm_rf(@controller_file)
    FileUtils.rm_rf(Mack::Paths.migrations)
    FileUtils.rm_rf(Mack::Paths.views("zoos"))
    FileUtils.rm_rf(Mack::Paths.model_tests)
    FileUtils.rm_rf(Mack::Paths.controller_tests)
    FileUtils.rm_rf(Mack::Paths.controller_helper_tests)
    FileUtils.rm_rf(Mack::Paths.controller_helpers)
    File.open(Mack::Paths.config("routes.rb"), "w") {|f| f.puts @old_route_file}
  end
  
  def zoo_options
    {"name" => "zoo", "cols" => "name:string,description:text,password:string,created_at:date_time,updated_at:date_time"}
  end
  
end