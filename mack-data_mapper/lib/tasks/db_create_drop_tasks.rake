require 'rake'
namespace :db do
  
  desc "Drops (if it exists) the database and then creates it for your environment."
  task :recreate => :environment do
    Mack::Database.drop(Mack.env)
    Mack::Database.create(Mack.env)
  end
  
  desc "Creates the database for your environment."
  task :create => :environment do
    Mack::Database.create(Mack.env)
  end
  
  desc "Drops the database for your environment."
  task :drop => :environment do
    Mack::Database.drop(Mack.env)
  end
  
  namespace :create do
    
    desc "Creates your test and development databases. Does NOT create your production database!"
    task :all => :environment do
      Mack::Database.create("test")
      Mack::Database.create("development")
    end
    
  end
  
  namespace :drop do
    
    desc "Drops your test and development databases. Does NOT create your production database!"
    task :all => :environment do
      Mack::Database.drop("test")
      Mack::Database.drop("development")
    end
    
  end
  
  namespace :recreate do
    
    desc "Drops and creates your test and development databases. Does NOT create your production database!"
    task :all => :environment do
      Mack::Database.drop("test")
      Mack::Database.create("test")
      Mack::Database.drop("development")
      Mack::Database.create("development")
    end
    
  end

end