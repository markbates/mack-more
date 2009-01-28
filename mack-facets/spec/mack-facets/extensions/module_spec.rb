require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Module do

  before(:all) do
    module ConvertMyMethodsPlease
      def foo
      end

      def bar
      end
    end

    module IncludeMeSafelyPlease
      def foo
      end

      def bar
      end
    end

    class LikeToBeSafe
    end
  end

  describe "convert_security_of_methods" do
    
    it "should convert the security of methods from one level to another" do
      ConvertMyMethodsPlease.public_instance_methods.should include("foo")
      ConvertMyMethodsPlease.public_instance_methods.should include("bar")
      ConvertMyMethodsPlease.convert_security_of_methods
      ConvertMyMethodsPlease.public_instance_methods.should_not include("foo")
      ConvertMyMethodsPlease.public_instance_methods.should_not include("bar")
      ConvertMyMethodsPlease.protected_instance_methods.should include("foo")
      ConvertMyMethodsPlease.protected_instance_methods.should include("bar")
      ConvertMyMethodsPlease.convert_security_of_methods(:protected, :private)
      ConvertMyMethodsPlease.protected_instance_methods.should_not include("foo")
      ConvertMyMethodsPlease.protected_instance_methods.should_not include("bar")
      ConvertMyMethodsPlease.private_instance_methods.should include("foo")
      ConvertMyMethodsPlease.private_instance_methods.should include("bar")
    end
    
  end
  
  describe "include_safely_into" do
    
    it "should include module methods as protected" do
      IncludeMeSafelyPlease.public_instance_methods.should include("foo")
      IncludeMeSafelyPlease.public_instance_methods.should include("bar")
      LikeToBeSafe.public_instance_methods.should_not include("foo")
      LikeToBeSafe.public_instance_methods.should_not include("bar")
      LikeToBeSafe.protected_instance_methods.should_not include("foo")
      LikeToBeSafe.protected_instance_methods.should_not include("bar")
      IncludeMeSafelyPlease.include_safely_into(LikeToBeSafe)
      LikeToBeSafe.public_instance_methods.should_not include("foo")
      LikeToBeSafe.public_instance_methods.should_not include("bar")
      LikeToBeSafe.protected_instance_methods.should include("foo")
      LikeToBeSafe.protected_instance_methods.should include("bar")
    end
    
  end

end