require File.join(File.dirname(__FILE__), "..", "spec_helper")

module Mack
  module FactoryTest

    class Database
      include Singleton

      def initialize
        @data = []
      end

      def add(obj)
        @data << obj
      end

      def list
        @data
      end   

      def empty?
        @data.empty?
      end

      def reset!
        @data = []
      end
    end

    class User
      attr_accessor :id
      attr_accessor :username
      attr_accessor :password
      attr_accessor :firstname
      attr_accessor :lastname

      def save
        puts "Saving user"
        Database.instance.add(self)
      end

      def to_s
        return "Username=#{username}\nPassword=#{password}\nFirstname=#{firstname}\nLastname=#{lastname}"
      end
    end

    class CustomOrm
      def can_handle(obj)
        return true
      end

      def get(obj, *args)
        Database.instance.list.each do |i|
          if i.is_a?(obj)
            return i
          end
        end
      end

      def count(obj, *args)
        count = 0
        Database.instance.list.each do |i|
          if i.is_a?(obj)
            count += 1
          end
        end
        return count
      end

      def save(obj, *args)
        obj.save
      end
    end
    Mack::Data::OrmRegistry.move_to_top(CustomOrm.new)

    class Item
      attr_accessor :id
      attr_accessor :owner_id
    end

    class ItemFactory
      include Mack::Data::Factory

      field :id, 1
      field :owner_id, {"Mack::FactoryTest::User" => "id"}
    end

    class UserFactory
      include Mack::Data::Factory

      field :id, 125
      field :username, "dsutedja", :immutable => true
      field :password, "password", :immutable => true
      field :firstname, "Firstname", :immutable => true
      field :lastname, "Lastname", :immutable => true

      scope_for(:diff_firstname) do
        field :firstname, "Darsono", :immutable => true
      end

      scope_for(:diff_first_lastname) do
        field :firstname, "Darsono", :immutable => true
        field :lastname, "Sutedja", :immutable => true
      end

      scope_for(:alpha_with_space) do
        field :firstname, "Darsono", :length => 128, :content => :alpha, :add_space => true
      end

      scope_for(:alpha_without_space) do
        field :firstname, "Darsono", :length => 128, :content => :alpha, :add_space => false
      end

      scope_for(:numeric_type) do
        field :id, 125, :content => :numeric, :num_start => 0, :num_end => 1000
      end

      scope_for(:alpha_numeric_with_space) do
        field :firstname, "Darsono", :length => 128, :content => :alpha_numeric, :add_space => true
      end

      scope_for(:alpha_numeric_without_space) do
        field :firstname, "Darsono", :length => 128, :content => :alpha_numeric, :add_space => false
      end

      scope_for(:custom_string_generator) do
        field :firstname, "Darsono" do |def_value, rules|
          "#{def_value} Sutedja"
        end
      end
    end

  end
end


describe "DataFactory" do

  describe "Module" do
    before(:each) do
      @factory = Mack::FactoryTest::UserFactory
    end

    it "should add create class_method to the factory object" do
      @factory.respond_to?(:create).should == true
    end

    it "should add field class_method to the factory object" do
      @factory.respond_to?(:field).should == true
    end

    it "should add scope_for class_method to the factory object" do
      @factory.respond_to?(:scope_for).should == true
    end
  end

  describe "Core Extension" do

    before(:each) do
      @factory = Mack::FactoryTest::UserFactory
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
        Mack::FactoryTest::UserFactory.create(1)
        Mack::FactoryTest::UserFactory.create(1, :diff_firstname)
      end

      factories(:hello, &proc)

      @map.registered_items[:hello].should_not be_nil
      @map.registered_items[:hello][0].should == proc
    end

    it "should be able to run the factory chains by tag" do
      @map.registered_items[:hello].should be_nil
      @db.should be_empty

      proc = Proc.new do
        Mack::FactoryTest::UserFactory.create(1)
        Mack::FactoryTest::UserFactory.create(1, :diff_firstname)
      end

      factories(:hello, &proc)

      run_factories(:hello)
      @db.should_not be_empty
      @db.list.size.should == 2

    end
  end

  describe "Creation" do
    before(:each) do
      @factory = Mack::FactoryTest::UserFactory
      @db  = Mack::FactoryTest::Database.instance
      @db.reset!
    end

    after(:each) do
      @db.reset!
    end

    it "should generate correct relationship if relationship rule is provided" do
      Mack::FactoryTest::UserFactory.create(10)
      Mack::FactoryTest::ItemFactory.create(1)
      
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

      Mack::FactoryTest::UserFactory.create(1)

      @db.list.size.should == 1
      user = @db.list[0]

      user.username.should == "dsutedja"
      user.password.should == "password"
      user.firstname.should == "Firstname"
      user.lastname.should == "Lastname"

    end

    it "should generate x number of scoped instances properly" do
      @db.should be_empty

      Mack::FactoryTest::UserFactory.create(1, :diff_firstname)

      @db.list.size.should == 1
      user = @db.list[0]

      user.username.should == "dsutedja"
      user.password.should == "password"
      user.firstname.should == "Darsono"
      user.lastname.should == "Lastname"
    end

    describe "using default generator" do
      before(:each) do
        @factory = Mack::FactoryTest::UserFactory
        @db  = Mack::FactoryTest::Database.instance
        @db.reset!
      end

      after(:each) do
        @db.reset!
      end

      it "should honor the add_space flag, length, and content type" do
        @db.should be_empty

        Mack::FactoryTest::UserFactory.create(1, :alpha_with_space)
        user = @db.list[0]
        user.firstname.size.should == 128     # 128 bytes of string
        user.firstname.should_not match(/\d/) # alphabet only
        user.firstname.should match(/ /)      # add_space = true

        @db.reset!
        Mack::FactoryTest::UserFactory.create(1, :alpha_without_space)
        user = @db.list[0]
        user.firstname.size.should == 128     # 128 bytes of string
        user.firstname.should_not match(/\d/) # alphabet only
        user.firstname.should_not match(/ /)      # add_space = true
      end

      it "should generate numeric type" do
        @db.should be_empty

        Mack::FactoryTest::UserFactory.create(1, :numeric_type)
        user = @db.list[0]
        user.id.is_a?(Fixnum).should == true
        num = user.id
        num.should >= 0
        num.should <= 1000
      end

      it "should generate alpha_numeric type" do
        @db.should be_empty

        Mack::FactoryTest::UserFactory.create(1, :alpha_numeric_with_space)
        user = @db.list[0]
        user.firstname.size.should == 128
        user.firstname.should match(/\d/)
        user.firstname.should match(/ /)
        user.firstname.should match(/[a-z]/)

        @db.reset!
        Mack::FactoryTest::UserFactory.create(1, :alpha_numeric_without_space)
        user = @db.list[0]
        user.firstname.size.should == 128
        user.firstname.should match(/\d/)
        user.firstname.should_not match(/ /)
        user.firstname.should match(/[a-z]/)

      end
    end

    it "should generate correct instance with custom content generator if provided" do
      @db.should be_empty

      Mack::FactoryTest::UserFactory.create(1, :custom_string_generator)
      user = @db.list[0]
      user.firstname.should == "Darsono Sutedja"
    end
  end

end