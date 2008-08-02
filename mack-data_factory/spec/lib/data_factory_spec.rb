require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "data_helpers")

describe "DataFactory" do
  
  describe "Content type" do
    before(:each) do
      @factory = Mack::FactoryTest::BigBangFactory
      @db  = Mack::FactoryTest::Database.instance
      @db.reset!
    end

    after(:each) do
      @db.reset!
    end
    
    it "should generate data based on content type spec" do
      @db.list.size.should == 0
      bigbang = @factory.create(1)
      bigbang.should_not be_nil
      
      bigbang.username.should_not be_nil
      bigbang.email.should_not be_nil
      bigbang.domain.should_not be_nil
      bigbang.firstname.should_not be_nil
      bigbang.lastname.should_not be_nil
      bigbang.fullname.should_not be_nil
      bigbang.streetname.should_not be_nil
      bigbang.city.should_not be_nil
      bigbang.zip.should_not be_nil
      bigbang.state.should_not be_nil
      bigbang.state_abbr.should_not be_nil
      bigbang.phone.should_not be_nil
      bigbang.company.should_not be_nil
      bigbang.company_with_bs.should_not be_nil
      
      bigbang.email.should match(/@/)
      bigbang.state_abbr.size.should == 2
      bigbang.fullname.should match(/\s/)
    end
  end

  describe "Module" do
    before(:each) do
      @user_factory = Mack::FactoryTest::UserFactory
    end

    it "should add create class_method to the factory object" do
      @user_factory.respond_to?(:create).should == true
    end

    it "should add field class_method to the factory object" do
      @user_factory.respond_to?(:field).should == true
    end

    it "should add scope_for class_method to the factory object" do
      @user_factory.respond_to?(:scope_for).should == true
    end
  end

  describe "Core Extension" do

    before(:each) do
      @user_factory = Mack::FactoryTest::UserFactory
      @map = Mack::Data::FactoryRegistryMap
      @db  = Mack::FactoryTest::Database.instance

      @map.reset!
    end

    before(:each) do
      @map.reset!
      @db.reset!
    end

    it "should be able to create factory chains" do
      @map.registered_items[:hello].should be_nil

      proc = Proc.new do
        @user_factory.create(1)
        @user_factory.create(1, :diff_firstname)
      end

      factories(:hello, &proc)

      @map.registered_items[:hello].should_not be_nil
      @map.registered_items[:hello][0].should == proc
    end

    it "should be able to run the factory chains by tag" do
      @map.registered_items[:hello].should be_nil
      @db.should be_empty

      proc = Proc.new do
        @user_factory.create(1)
        @user_factory.create(1, :diff_firstname)
      end

      factories(:hello, &proc)

      run_factories(:hello)
      @db.should_not be_empty
      @db.list.size.should == 2

    end
  end

  describe "Creation" do
    before(:each) do
      @user_factory = Mack::FactoryTest::UserFactory
      @item_factory = Mack::FactoryTest::ItemFactory
      @db  = Mack::FactoryTest::Database.instance
      @db.reset!
    end

    after(:each) do
      @db.reset!
    end
    
    it "should return constructed object when create is called" do
      user = @user_factory.create(1)
      users = @user_factory.create(10)
      
      user.kind_of?(Array).should_not == true
      users.kind_of?(Array).should == true
      
      users.size.should == 10
    end

    it "should generate correct relationship if relationship rule is provided" do
      @user_factory.create(10)
      @item_factory.create(1)
      
      check = false
      item = @db.list.last
      @db.list.each do |i|
        if i.is_a?Mack::FactoryTest::User
          check = true if item.id == i.id
        end
      end
      check.should == true
    end

    it "should generate x number of instances with no random data if immutable flag is set" do
      @db.should be_empty

      @user_factory.create(1)

      @db.list.size.should == 1
      user = @db.list[0]

      user.username.should == "dsutedja"
      user.password.should == "password"
      user.firstname.should == "Firstname"
      user.lastname.should == "Lastname"

    end

    it "should generate x number of scoped instances properly" do
      @db.should be_empty

      @user_factory.create(1, :diff_firstname)

      @db.list.size.should == 1
      user = @db.list[0]

      user.username.should == "dsutedja"
      user.password.should == "password"
      user.firstname.should == "Darsono"
      user.lastname.should == "Lastname"
    end

    describe "using default generator" do
      before(:each) do
        @user_factory = Mack::FactoryTest::UserFactory
        @db  = Mack::FactoryTest::Database.instance
        @db.reset!
      end

      after(:each) do
        @db.reset!
      end

      it "should honor the add_space flag, length, and content type" do
        @db.should be_empty

        @user_factory.create(1, :alpha_with_space)
        user = @db.list[0]
        user.firstname.size.should == 128     # 128 bytes of string
        user.firstname.should_not match(/\d/) # alphabet only
        user.firstname.should match(/ /)      # add_space = true

        @db.reset!
        @user_factory.create(1, :alpha_without_space)
        user = @db.list[0]
        user.firstname.size.should == 128     # 128 bytes of string
        user.firstname.should_not match(/\d/) # alphabet only
        user.firstname.should_not match(/ /)      # add_space = true
      end

      it "should generate numeric type" do
        @db.should be_empty

        @user_factory.create(1, :numeric_type)
        user = @db.list[0]
        user.id.is_a?(Fixnum).should == true
        num = user.id
        num.should >= 0
        num.should <= 1000
      end

      it "should generate alpha_numeric type" do
        @db.should be_empty

        @user_factory.create(1, :alpha_numeric_with_space)
        user = @db.list[0]
        user.firstname.size.should == 128
        user.firstname.should match(/\d/)
        user.firstname.should match(/ /)
        user.firstname.should match(/[a-z]/)

        @db.reset!
        @user_factory.create(1, :alpha_numeric_without_space)
        user = @db.list[0]
        user.firstname.size.should == 128
        user.firstname.should match(/\d/)
        user.firstname.should_not match(/ /)
        user.firstname.should match(/[a-z]/)

      end
    end

    it "should generate correct instance with custom content generator if provided" do
      @db.should be_empty

      @user_factory.create(1, :custom_string_generator)
      user = @db.list[0]
      user.firstname.should == "Darsono Sutedja"
    end
  end

end