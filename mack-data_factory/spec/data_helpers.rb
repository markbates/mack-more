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