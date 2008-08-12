namespace :db do

  desc "Displays the current schema version of your database"
  task :version => "mack:environment" do
    puts "\nYour database is currently at version: #{Mack::Database::Migrations.version}\n"
  end # version
  
end # db