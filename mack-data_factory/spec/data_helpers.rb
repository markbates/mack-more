module Mack
  module FactoryTest

    class Database
      include Singleton

      def initialize
        @data = {}
      end

      def add(tag, obj)
        #puts "Adding #{tag} <-- #{obj}"
        list(tag) << obj
      end

      def list(tag)
        @data[tag] ||= []
        return @data[tag]
      end
      
      def clean?
        @data.empty?
      end   

      def empty?(tag)
        list(tag).empty?
      end

      def reset!
        @data = {}
      end
    end


    class CustomOrm
      def can_handle(obj)
        return true
      end

      def get(obj, *args)
      end
      
      def get_all(obj, *args)
        return Database.instance.list(obj.name.underscore.to_sym).dup
        return Database.instance.list.dup
      end
      
      def get_first(obj, *args)
      end
      
      def count(obj, *args)
        return Database.instance.list(obj.name.underscore.to_sym).size
      end
    end
    Mack::Data::OrmRegistry.move_to_top(CustomOrm.new)

    class User
      attr_accessor :id
      attr_accessor :username
      attr_accessor :password
      attr_accessor :firstname
      attr_accessor :lastname

      def save
        # puts "saving user to #{User.name.underscore.to_sym}"
        Database.instance.add(User.name.underscore.to_sym, self)
      end

      def to_s
        return "User --> id=#{id}, pass=#{password}, uname=#{username}\n"
        #return "Username=#{username}\nPassword=#{password}\nFirstname=#{firstname}\nLastname=#{lastname}"
      end
    end
    
    
    class Item
      attr_accessor :id
      attr_accessor :owner_id
      
      def save
        # puts "saving items"
        Database.instance.add(Item.name.underscore.to_sym, self)
      end
      
      def to_s
        return "Item --> id=#{id}, owner_id=#{owner_id}"
      end
    end

    class ItemFactory
      include Mack::Data::Factory

      field :id, 0 do |def_value, rules, index|
        index
      end
      association :owner_id, {Mack::FactoryTest::User => "id"}
      
      scope_for(:relationship_first) do
        association :owner_id, {Mack::FactoryTest::User => "id"}, :first
      end
      
      scope_for(:relationship_last) do
        association :owner_id, {Mack::FactoryTest::User => "id"}, :last
      end
      
      scope_for(:relationship_random) do
        association :owner_id, {Mack::FactoryTest::User => :id}, :random
      end
      
      scope_for(:relationship_spread) do
        association :owner_id, {Mack::FactoryTest::User => "id"}, :spread
      end      
    end
    
    class BigBang
      attr_accessor :username
      attr_accessor :email
      attr_accessor :domain
      attr_accessor :firstname
      attr_accessor :lastname
      attr_accessor :fullname
      attr_accessor :streetname
      attr_accessor :city
      attr_accessor :zip
      attr_accessor :state
      attr_accessor :state_abbr
      attr_accessor :phone
      attr_accessor :company
      attr_accessor :company_with_bs
      
      def save
        # puts "saving big bang"
        Database.instance.add(BigBang.name.underscore.to_sym, self)
      end
      
    end
    
    class BigBangFactory
      include Mack::Data::Factory
      
      field :username,      "", :content => :username
      field :email,         "", :content => :email
      field :domain,        "", :content => :domain
      field :firstname,     "", :content => :firstname
      field :lastname,      "", :content => :lastname
      field :fullname,      "", :content => :name
      field :streetname,    "", :content => :streetname
      field :city,          "", :content => :city
      field :zip,           "", :content => :zipcode, :country => :us
      field :state,         "", :content => :state, :country => :us
      field :state_abbr,    "", :content => :state, :country => :us, :abbr => true
      field :phone,         "", :content => :phone
      field :company,       "", :content => :company
      field :company_with_bs, "", :content => :company, :include_bs => true
    end

    class UserFactory
      include Mack::Data::Factory

      field :id, 0 do |def_value, rules, index|
        index
      end
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