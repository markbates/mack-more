require 'rake'
namespace :db do
  
  desc "Drops (if it exists) the database and then creates it for your environment."
  task :recreate => :environment do
    Mack::Database.drop(Mack.env, repis)
    Mack::Database.create(Mack.env, repis)
  end
  
  desc "Creates the database for your environment."
  task :create => :environment do
    Mack::Database.create(Mack.env, repis)
  end
  
  desc "Drops the database for your environment."
  task :drop => :environment do
    Mack::Database.drop(Mack.env, repis)
  end
  
  namespace :create do
    
    desc "Creates your test and development databases. Does NOT create your production database!"
    task :all => :environment do
      Mack::Database.create("test", repis)
      Mack::Database.create("development", repis)
    end
    
  end
  
  namespace :drop do
    
    desc "Drops your test and development databases. Does NOT create your production database!"
    task :all => :environment do
      Mack::Database.drop("test", repis)
      Mack::Database.drop("development", repis)
    end
    
  end
  
  namespace :recreate do
    
    desc "Drops and creates your test and development databases. Does NOT create your production database!"
    task :all => :environment do
      Mack::Database.drop("test", repis)
      Mack::Database.create("test", repis)
      Mack::Database.drop("development", repis)
      Mack::Database.create("development", repis)
    end
    
  end
  
  private
  def repis
    (ENV["REPO"] ||= "default").to_sym
  end

end