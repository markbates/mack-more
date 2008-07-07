require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe ScaffoldGenerator do
  include Mack::Genosaurus::Helpers

  before(:each) do
    @view_path  = File.join(Mack.root, "app", "views", "zoos")
    @view_files = ['new.html.erb', 'index.html.erb', 'edit.html.erb', 'show.html.erb']
    
    @cont_path  = File.join(Mack.root, "app", "controllers")
    @cont_file  = File.join(@cont_path, "zoos_controller.rb")
    
    @model_path = File.join(Mack.root, "app", "models")
    @model_file = File.join(@model_path, "zoo.rb")
    
    @mig_file = File.join(migrations_directory, "#{next_migration_number}_create_zoos.rb")
    @cont_test_file = File.join(Mack.root, "test", "functional", "zoos_controller_test.rb")
    @model_test_file = File.join(Mack.root, "test", "unit", "zoo_test.rb")
    
    @routes_file = File.join(Mack.root, "config", "routes.rb")
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
    temp_app_config("mack::testing_framework" => "rspec") do
      ScaffoldGenerator.run("NAME" => "zoo")
      @cont_test_file = File.join(Mack.root, "test", "functional", "zoos_controller_spec.rb")
      @model_test_file = File.join(Mack.root, "test", "unit", "zoo_spec.rb")
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