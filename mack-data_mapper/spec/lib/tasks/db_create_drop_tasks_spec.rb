require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe "rake" do

  describe "db" do
  
    describe "create" do
    
      it "should create a MySQL db for the current environment"
    
      it "should create a PostgreSQL db for the current environment"
    
      it "should drop/create a MySQL db if it already exists for the current environment"
    
      it "should drop/create a PostgreSQL db if it already exists for the current environment"
    
      it "should create a MySQL db for the specified environment"
    
      it "should create a PostgreSQL db for the specified environment"
    
      it "should drop/create a MySQL db if it already exists for the specified environment"
    
      it "should drop/create a PostgreSQL db if it already exists for the specified environment"
    
      describe "all" do
      
        it "should create a MySQL db for all environments"

        it "should create a PostgreSQL db for all environments"

        it "should drop/create a MySQL db all environments"

        it "should drop/create a PostgreSQL db all environments"
      
      end
    
    end
  
  end
  
end