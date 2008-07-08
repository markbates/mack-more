require 'rake'
namespace :db do
  
  desc "Create the database for your environment."
  task :create => :environment do
    Mack::Database.create(Mack.env)
  end
  
  namespace :create do
    
    desc "Creates your Full environment. Does NOT create your production database!"
    task :all => :environment do
      Mack::Database.create("test")
      Mack::Database.create("development")
      Rake::Task["db:migrate"].invoke
    end
    
  end

end