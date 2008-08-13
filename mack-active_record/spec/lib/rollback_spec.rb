require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe "Rollback Transaction" do
  
  def before_spec_extension
    app_config.load_hash({"disable_transactional_tests" => false}, "rollback")
  end
  
  def after_spec_extension
    app_config.load_hash({"disable_transactional_tests" => true}, "rollback")
  end

  before(:each) do
    Mack::Database::Migrations.migrate
    User.count.should == 0
    User.create(:username => 'foo')
    User.count.should == 1
  end
  
  after(:each) do
    User.count.should == 2
    User.create(:username => 'foo3')
    User.count.should == 3
  end
  
  it "should roll back transaction after each test" do
    User.count.should == 1
    User.create(:username => 'foo2')
    User.count.should == 2
  end
  
  it "should roll back transaction after each test - take 2" do
    User.count.should == 1
    User.create(:username => 'foo2')
    User.count.should == 2
  end
  
end
