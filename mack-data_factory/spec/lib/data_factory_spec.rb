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
    
    class UserFactory
      include Mack::Data::Factory

      field :username, "dsutedja"
      field :password, "password"
      field :firstname, "Firstname"
      field :lastname, "Lastname"

      scope_for(:diff_firstname) do
        field :firstname, "Darsono"
      end

      scope_for(:diff_first_lastname) do
        field :firstname, "Darsono"
        field :lastname, "Sutedja"
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
  
  # describe "With no override" do
  #   it "should generate default values for the model"
  #   it "should generate correct relationship for the model"
  #   it "should generate correct value type for each attribute in the model"
  #   it "should generate x number of instances properly"
  # end

  describe "Creation" do
    before(:each) do
      @factory = Mack::FactoryTest::UserFactory
      @db  = Mack::FactoryTest::Database.instance
      @db.reset!
    end
    
    after(:each) do
      @db.reset!
    end
    
    it "should generate the value correctly based on the rules"
    it "should generate correct relationship if relationship rule is provided"
    
    it "should generate x number of instances properly" do
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
      
    it "should generate correct instance with default content generator"
    it "should generate correct instance with custom content generator if provided"
  end

  describe "Custom rules" do
    it "should generate 100 bytes of random string if :length is set"
    it "should generate 100 bytes of random string with spaces in between if :length and :add_space are set"
    it "should generate up to 100 bytes of random string if :max_length (and ignore :length)"
    it "should generate minimum of 100 bytes of random string if :min_length (and ignore :length) "
    it "should generate from 100-500 bytes of random string if :min and :max_length is set (and ignore :length)"
    it "should generate up to 100 bytes of random string with spaces if :add_space and :max_length (and ignore :length)"
    it "should generate minimum of 100 bytes of random string with spaces if :add_space and :min_length (and ignore :length) "
    it "should generate from 100-500 bytes of random string with spaces if :add_space and :min and :max_length is set (and ignore :length)"
    it "should only generate alphabets in the random string if :content is set to :alpha"
    it "should only generate numerics in the random string if :content is set to :numeric"
    it "should only generate alphanumerics in the random string if :content is set to :alpha_numeric"
    it "should have 0% of null value occurrences if :null_frequency is set to 0"
    it "should have 100% of null value occurrences if :null_frequency is set to 100"
    it "should have about 20% of null value occurrences if :null_frequency is set to 20"
    it "should generate the same value accross all instances if :immutable is set"
  end

end