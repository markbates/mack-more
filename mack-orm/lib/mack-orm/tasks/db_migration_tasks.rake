namespace :db do
  
  desc "Migrate the database through scripts in db/migrations."
  task :migrate => "mack:environment" do
    Mack::Database::Migrations.migrate
  end # migrate
  
  desc "Rolls the schema back to the previous version. Specify the number of steps with STEP=n."
  task :rollback => ["mack:environment", "db:abort_if_pending_migrations"] do
    Mack::Database::Migrations.rollback((ENV["STEP"] || 1).to_i)
  end # rollback
  
  desc "Raises an error if there are pending migrations."
  task :abort_if_pending_migrations do
    Mack::Database::Migrations.abort_if_pending_migrations
  end
  
end # db