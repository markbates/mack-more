require 'rake'
namespace :test do
  
  desc "Sets up your testing environment"
  task :setup do
    ENV["MACK_ENV"] = "test"
    Mack.reset_logger!
    Rake::Task["db:recreate"].invoke
    Mack::Database.dump_structure("development", :default)
    Mack::Database.load_structure(File.join(Mack.root, "db", "development_schema_structure.sql"))
    Rake::Task["test:factories:run"].invoke
  end # setup
  
  namespace :factories do
  
    desc "If using the mack-data_factory it will require your factories and run the 'init' factories"
    task :run do
      if respond_to?(:run_factories)
        # auto require factories:
        Dir.glob(File.join(Mack.root, "test", "factories", "**/*.rb")).each do |f|
          require f
        end
        run_factories(:init)
      end
    end # run
    
  end # factories
  
end # test