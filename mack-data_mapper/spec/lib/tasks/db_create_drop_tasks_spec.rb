require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe "rake" do

  describe "db" do
  
    describe "create" do

      
      describe "(MySQL)" do
        before(:all) do
          @db_yml = File.read(Mack::Paths.config("database.yml"))
          File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts fixture("mysql_database.yml")}
          DataMapper.setup(:test_tmp, "mysql://root@localhost/mysql")
          repository(:test_tmp).adapter.execute "DROP DATABASE IF EXISTS `mack_data_mapper_development`"
        end
      
        after(:all) do
          File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts @db_yml}
          repository(:test_tmp).adapter.execute "DROP DATABASE IF EXISTS `mack_data_mapper_development`"
        end
      
        it "should create a db for the current environment" do
          repository(:test_tmp).adapter.query("show databases;").should_not include("mack_data_mapper_development")
          Mack::Database.create("development")
          repository(:test_tmp).adapter.query("show databases;").should include("mack_data_mapper_development")
        end
      
        it "should drop/create a db if it already exists for the current environment"
      
        it "should create a db for the specified environment" do
          repository(:test_tmp).adapter.query("show databases;").should_not include("mack_data_mapper_test")
          Mack::Database.create("test")
          repository(:test_tmp).adapter.query("show databases;").should include("mack_data_mapper_test")
        end
      
        it "should drop/create a db if it already exists for the specified environment"
        
      end
      
      describe "(PostgreSQL)" do
        
        before(:all) do
          @db_yml = File.read(Mack::Paths.config("database.yml"))
          File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts fixture("postgresql_database.yml")}
        end
        
        after(:all) do
          File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts @db_yml}
        end
        
        it "should create a db for the current environment"
        
        it "should drop/create a db if it already exists for the current environment"
        
        it "should create a db for the specified environment"
        
        it "should drop/create a db if it already exists for the specified environment"
        
      end
    
      describe "all" do
        
        describe "(MySQL)" do
          
          before(:all) do
            @db_yml = File.read(Mack::Paths.config("database.yml"))
            File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts fixture("mysql_database.yml")}
          end

          after(:all) do
            File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts @db_yml}
          end
          
          it "should create a db for all environments"
          
          it "should drop/create a db all environments"
          
        end
        
        describe "(PostgreSQL)" do
          
          before(:all) do
            @db_yml = File.read(Mack::Paths.config("database.yml"))
            File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts fixture("postgresql_database.yml")}
          end

          after(:all) do
            File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts @db_yml}
          end
          
          it "should create a db for all environments"
          
          it "should drop/create a db all environments"
          
        end
      
      end
    
    end
  
  end
  
end