require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe ScaffoldGenerator do
  include Mack::Genosaurus::Orm::Helpers

  before(:each) do
    FileUtils.rm_rf(Mack::Paths.controller_helpers)
    FileUtils.rm_rf(Mack::Paths.test_helpers)
    @view_path  = Mack::Paths.views("zoos")
    @view_files = ['new.html.erb', 'index.html.erb', 'edit.html.erb', 'show.html.erb']
    
    @cont_file  = Mack::Paths.controllers("zoos_controller.rb")
    
    @model_file = Mack::Paths.models("zoo.rb")
    
    @mig_file = Mack::Paths.migrations("#{next_migration_number}_create_zoos.rb")
    @cont_test_file = Mack::Paths.controller_tests("zoos_controller_test.rb")
    @model_test_file = Mack::Paths.model_tests("zoo_test.rb")
    
    @routes_file = Mack::Paths.config("routes.rb")
    @orig_routes_content = File.read(@routes_file)
  end
  
  after(:each) do    
    FileUtils.rm_rf(@view_path)
    
    cleanup(@cont_file)
    cleanup(@model_file)
    cleanup(@mig_file)
    cleanup(@cont_test_file)
    cleanup(@model_test_file)
    
    # rewrite routes file
    File.open(@routes_file, "w") {|f| f.write(@orig_routes_content)}
    FileUtils.rm_rf(Mack::Paths.controller_helpers)
    FileUtils.rm_rf(Mack::Paths.test_helpers)
  end
  
  it "should require a name for the scaffold" do
    lambda { ScaffoldGenerator.new }.should raise_error(ArgumentError)
  end
  
  it "should handle plural/singular names correctly" do
    ScaffoldGenerator.run("NAME" => "zoo")
    
    # controller -> (plural_form)_controller.rb
    # model -> (singular_form).rb
    # views -> app/views/(plural_form)/.
    # migraiton -> XXX_create_(plural_form).rb
    File.exists?(@view_path).should == true
    File.exists?(@cont_file).should == true
    File.exists?(@model_file).should == true
    File.exists?(@mig_file)
  end
  
  it "should update the routes.rb file with the resource name" do
    ScaffoldGenerator.run("NAME" => "zoo")
    File.exists?(@routes_file).should == true
    File.read(@routes_file).should match(/r.resource :zoos # Added by rake generate:scaffold name=zoo/)
  end
  
  it "should create a stub test/unit test for the controller if test/unit is testing framework" do
    ScaffoldGenerator.run("NAME" => "zoo")
    File.exists?(@cont_test_file).should == true
  end
  
  it "should create a stub rspec test for the controller if rspec is testing framework" do
    temp_app_config(:mack => {:testing_framework => "rspec"}) do
      ScaffoldGenerator.run("NAME" => "zoo")
      @cont_test_file = Mack::Paths.controller_tests("zoos_controller_spec.rb")
      @model_test_file = Mack::Paths.model_tests("zoo_spec.rb")
      File.exists?(@cont_test_file).should == true    
    end
  end
  
  it "should create a controller file" do
    ScaffoldGenerator.run("NAME" => "zoo")
    File.exists?(@cont_file).should == true
  end
  
  it "should create the proper view files" do
    ScaffoldGenerator.run("NAME" => "zoo")
    @view_files.each do |file|
      gen_file = File.join(@view_path, file)
      File.exists?(gen_file).should == true
    end
  end
  
  it "should create a model file" do
    ScaffoldGenerator.run("NAME" => "zoo")
    File.exists?(@model_file).should == true
  end
  
  it "should create a migration file" do
    ScaffoldGenerator.run("NAME" => "zoo")
    File.exists?(@mig_file).should == true
  end
  
end