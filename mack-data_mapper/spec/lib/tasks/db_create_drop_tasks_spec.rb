require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe "rake" do

  describe "db" do
  
    describe "create" do
      
      def common_mysql_cleanup
        repository(:mysql_test_tmp) do |repo|
          repo.adapter.execute "DROP DATABASE IF EXISTS `mack_data_mapper_development`"
          repo.adapter.execute "DROP DATABASE IF EXISTS `mack_data_mapper_test`"
          repo.adapter.execute "DROP DATABASE IF EXISTS `mack_data_mapper_production`"
        end
      end
      
      def common_postgres_cleanup
        # repository(:postgres_test_tmp) do |repo|
        #   repo.adapter.execute "DROP DATABASE IF EXISTS mack_data_mapper_development"
        #   repo.adapter.execute "DROP DATABASE IF EXISTS mack_data_mapper_test"
        #   repo.adapter.execute "DROP DATABASE IF EXISTS mack_data_mapper_production"
        # end
      end
      
      class Zombie
        include DataMapper::Resource
        
        property :id, Serial
        property :name, String
      end
      
      describe "(MySQL)" do
        before(:all) do
          @db_yml = File.read(Mack::Paths.config("database.yml"))
          File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts fixture("mysql_database.yml")}
          DataMapper.setup(:mysql_test_tmp, "mysql://root@localhost/mysql")
          common_mysql_cleanup
        end
      
        after(:all) do
          File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts @db_yml}
          common_mysql_cleanup
        end
      
        it "should create a db for the current environment" do
          repository(:mysql_test_tmp) do |repo|
            repo.adapter.query("show databases;").should_not include("mack_data_mapper_test")
            Mack::Database.create
            repo.adapter.query("show databases;").should include("mack_data_mapper_test")
          end
        end
      
        it "should drop/create a db if it already exists for the current environment" do
          repository(:mysql_test_tmp) do |repo|
            Mack::Database.create
            Zombie.should_not be_storage_exist
            Zombie.auto_migrate!
            Zombie.should be_storage_exist
            Mack::Database.create
            Zombie.should_not be_storage_exist
          end
        end
      
        it "should create a db for the specified environment" do
          repository(:mysql_test_tmp) do |repo|
            repo.adapter.query("show databases;").should_not include("mack_data_mapper_production")
            Mack::Database.create("production")
            repo.adapter.query("show databases;").should include("mack_data_mapper_production")
          end
        end
      
        it "should drop/create a db if it already exists for the specified environment" do
          repository(:mysql_test_tmp) do |repo|
            Mack::Database.create("production")
            Zombie.should_not be_storage_exist
            Zombie.auto_migrate!
            Zombie.should be_storage_exist
            Mack::Database.create("production")
            Zombie.should_not be_storage_exist
          end
        end
        
      end
      
      describe "(PostgreSQL)" do
        
        before(:all) do
          @db_yml = File.read(Mack::Paths.config("database.yml"))
          File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts fixture("postgresql_database.yml")}
          DataMapper.setup(:postgres_test_tmp, "postgres://ruby:password@localhost/postgres")
          # common_postgres_cleanup
        end
        
        after(:all) do
          File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts @db_yml}
          # common_postgres_cleanup
        end
        
        it "should create a db for the current environment" do
          # rollback_transaction do
            repository(:postgres_test_tmp) do |repo|
              repo.adapter.query("select datname from pg_database").should_not include("mack_data_mapper_test")
              Mack::Database.create
              repo.adapter.query("select datname from pg_database").should include("mack_data_mapper_test")
            end
          # end
        end
      
        it "should drop/create a db if it already exists for the current environment" do
          # rollback_transaction do
            repository(:postgres_test_tmp) do |repo|
              Mack::Database.create
              Zombie.should_not be_storage_exist
              Zombie.auto_migrate!
              Zombie.should be_storage_exist
              Mack::Database.create
              Zombie.should_not be_storage_exist
            end
          # end
        end
      
        it "should create a db for the specified environment" do
          # rollback_transaction do
            repository(:postgres_test_tmp) do |repo|
              repo.adapter.query("select datname from pg_database").should_not include("mack_data_mapper_production")
              Mack::Database.create("production")
              repo.adapter.query("select datname from pg_database").should include("mack_data_mapper_production")
            end
          # end
        end
      
        it "should drop/create a db if it already exists for the specified environment" do
          # rollback_transaction do
            repository(:postgres_test_tmp) do |repo|
              Mack::Database.create("production")
              Zombie.should_not be_storage_exist
              Zombie.auto_migrate!
              Zombie.should be_storage_exist
              Mack::Database.create("production")
              Zombie.should_not be_storage_exist
            end
          # end
        end
        
      end
    
      describe "all" do
        
        describe "(MySQL)" do
          
          before(:all) do
            @db_yml = File.read(Mack::Paths.config("database.yml"))
            File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts fixture("mysql_database.yml")}
            common_mysql_cleanup
          end

          after(:all) do
            File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts @db_yml}
            common_mysql_cleanup
          end
          
          it "should create a db for all environments" do
            repository(:mysql_test_tmp) do |repo|
              repo.adapter.query("show databases;").should_not include("mack_data_mapper_test")
              repo.adapter.query("show databases;").should_not include("mack_data_mapper_development")
              rake_task("db:create:all")
              repo.adapter.query("show databases;").should include("mack_data_mapper_test")
              repo.adapter.query("show databases;").should include("mack_data_mapper_development")
            end
          end
          
        end
        
        describe "(PostgreSQL)" do
          
          before(:all) do
            @db_yml = File.read(Mack::Paths.config("database.yml"))
            File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts fixture("postgresql_database.yml")}
            common_postgres_cleanup
          end

          after(:all) do
            File.open(Mack::Paths.config("database.yml"), "w") {|f| f.puts @db_yml}
            common_postgres_cleanup
          end
          
          it "should create a db for all environments"
          
        end
      
      end
    
    end
  
  end
  
end