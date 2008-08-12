# require 'pathname'
# require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'
# 
# describe Mack::Database::Migrations do
#   
#     class Zoo
#       include DataMapper::Resource
#       
#       property :id, Serial
#       property :name, String
#       property :description, Text
#       property :created_at, DateTime
#       property :updated_at, DateTime
#     end
#     
#     class Animal
#       include DataMapper::Resource
#       
#       property :id, Serial
#     end
#     
#     before(:each) do
#       Mack::Database.recreate
#       FileUtils.rm_rf(Mack::Paths.migrations)
#       FileUtils.mkdir_p(Mack::Paths.migrations)
#       File.open(Mack::Paths.migrations("001_create_zoos.rb"), "w") {|f| f.puts fixture("create_zoos.rb")}
#     end
# 
#     after(:each) do
#       FileUtils.rm_rf(Mack::Paths.migrations)
#     end
#   
#     describe "migrate" do
#     
#       it "should migrate the database with the migrations in the db/migrations folder" do
#         Zoo.should_not be_storage_exists
#         Mack::Database::Migrations.migrate
#         Zoo.should be_storage_exists
#       end
#     
#     end
#   
#     describe "rollback" do
#     
#       it "should rollback the database by a default of 1 step" do
#         Zoo.should_not be_storage_exists
#         Mack::Database::Migrations.migrate
#         Zoo.should be_storage_exists
#         Mack::Database::Migrations.rollback
#         Zoo.should_not be_storage_exists
#       end
#     
#       it "should rollback the database by n steps if ENV['STEP'] is set" do
#         Zoo.should_not be_storage_exists
#         Animal.should_not be_storage_exists
#         File.open(Mack::Paths.migrations("002_create_animals.rb"), "w") {|f| f.puts fixture("create_animals.rb")}
#         Mack::Database::Migrations.migrate
#         Zoo.should be_storage_exists
#         Animal.should be_storage_exists
#         Mack::Database::Migrations.rollback(2)
#         Zoo.should_not be_storage_exists
#         Animal.should_not be_storage_exists
#       end
#     
#     end
#   
# end