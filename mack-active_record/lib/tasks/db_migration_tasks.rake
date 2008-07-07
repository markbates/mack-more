require 'rake'
namespace :db do
  
  desc "Migrate the database through scripts in db/migrations"
  task :migrate => "mack:environment" do
    ActiveRecord::Migrator.up(File.join(Mack.root, "db", "migrations"))
  end # migrate
  
  desc "Rolls the schema back to the previous version. Specify the number of steps with STEP=n"
  task :rollback => ["mack:environment"] do
    ActiveRecord::Migrator.rollback(File.join(Mack.root, "db", "migrations"), (ENV["STEP"] || 1).to_i)
  end # rollback

  desc "Displays the current schema version of your database"
  task :version => "mack:environment" do
    puts "\nYour database is currently at version: #{ActiveRecord::Migrator.current_version}\n"
  end
  
end # db