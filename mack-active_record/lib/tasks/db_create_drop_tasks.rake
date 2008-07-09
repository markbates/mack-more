require 'rake'
require 'ruby-debug'
namespace :db do
    
  task :drop => :environment do
    Mack::Database.drop_or_create_database(Mack.env, :drop)    
  end
  
  namespace :drop do 
    desc "Drop databases for both development and test environemnt"
    task :all => :environment do
      Mack::Database.drop_or_create_database("development", :drop)
      Mack::Database.drop_or_create_database("test", :drop)
    end
  end
  
  
  # task :create do
  #   puts Mack.env
  #   Mack::Database.drop_or_create_database(Mack.env, :create)
  # end
  
  # task :recreate do
  #   puts Mack.env
  #   Mack::Database.drop_or_create_database(Mack.env, :drop_and_create)
  # end
  
  # namespace :create do
  #   desc "Creates your Full environment. Does NOT create your production database!"
  #   task :all => :environment do
  #     abcs = YAML::load(ERB.new(IO.read(File.join(Mack.root, "config", "database.yml"))).result)
  #     db_settings = abcs[Mack.env]
  #     
  #     Mack::Database.drop_or_create_database("development", :create)
  #     Mack::Database.drop_or_create_database("test", :create)
  #     ActiveRecord::Base.establish_connection(db_settings)
  #     Rake::Task["db:migrate"].invoke
  #   end
  # end
  
  # namespace :recreate do
  #   desc "Creates your Full environment. Does NOT create your production database!"
  #   task :all => :environment do
  #     abcs = YAML::load(ERB.new(IO.read(File.join(Mack.root, "config", "database.yml"))).result)
  #     db_settings = abcs[Mack.env]
  #     
  #     Mack::Database.drop_or_create_database("development")
  #     Mack::Database.drop_or_create_database("test")
  #     ActiveRecord::Base.establish_connection(db_settings)
  #     Rake::Task["db:migrate"].invoke
  #   end
  # end
  
  desc "Create the database for your environment."
  task :create => :environment do
    puts Mack.env
    Mack::Database.drop_or_create_database(Mack.env)
  end
  
  namespace :create do
    desc "Creates your Full environment. Does NOT create your production database!"
    task :all => :environment do
      abcs = YAML::load(ERB.new(IO.read(File.join(Mack.root, "config", "database.yml"))).result)
      db_settings = abcs[Mack.env]
      
      Mack::Database.drop_or_create_database("development")
      Mack::Database.drop_or_create_database("test")
      ActiveRecord::Base.establish_connection(db_settings)
      Rake::Task["db:migrate"].invoke
    end
  end
  
end
