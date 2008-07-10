require 'rake'
namespace :db do
  
  desc "Migrate the database through scripts in db/migrations"
  task :migrate => "mack:environment" do
    #ActiveRecord::Migrator.up(File.join(Mack.root, "db", "migrations"))
    Mack::Database::Migrator.migrate
  end # migrate
  
  desc "Rolls the schema back to the previous version. Specify the number of steps with STEP=n"
  task :rollback => ["mack:environment"] do
    Mack::Database::Migrator.rollback
    #ActiveRecord::Migrator.rollback(File.join(Mack.root, "db", "migrations"), (ENV["STEP"] || 1).to_i)
  end # rollback

  desc "Displays the current schema version of your database"
  task :version => "mack:environment" do
    puts "\nYour database is currently at version: #{Mack::Database::Migrator.version}\n"
  end
  
end # db