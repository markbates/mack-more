namespace :test do
  
  task :setup do
    ENV["MACK_ENV"] = "test"
    Mack.reset_logger!
    Rake::Task["db:recreate"].invoke
    Mack::Database.dump_structure("development", :default)
    Mack::Database.load_structure(File.join(Mack.root, "db", "development_default_schema_structure.sql"))
    
    # auto require factories:
    Dir.glob(File.join(Mack.root, "test", "factories", "**/*.rb")).each do |f|
      require f
    end
    
    run_factories(:init) if respond_to?(:run_factories)
  end
  
end