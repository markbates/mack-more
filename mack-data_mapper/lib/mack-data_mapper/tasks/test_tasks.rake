namespace :test do
  
  task :setup => "mack:environment" do
    unless ENV["MACK_TEST_ENV_SETUP?"] == "true"
      ENV["MACK_ENV"] = "test"
      Rake::Task["db:recreate"].invoke
      Mack::Database.dump_structure("development", :default)
      Mack::Database.load_structure(File.join(Mack.root, "db", "development_default_schema_structure.sql"))
      ENV["MACK_TEST_ENV_SETUP?"] = "true"
    end
  end
  
end