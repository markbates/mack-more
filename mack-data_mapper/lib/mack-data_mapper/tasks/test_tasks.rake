namespace :test do
  
  task :setup do
    unless ENV["MACK_TEST_ENV_SETUP?"] == "true"
      ENV["MACK_ENV"] = "test"
      Rake::Task["db:recreate"].invoke
      # Rake::Task["db:structure:dump"].invoke
      Mack::Database.structure_dump("development", :default)
      Rake::Task["db:migrate"].invoke
      ENV["MACK_TEST_ENV_SETUP?"] = "true"
    end
  end
  
end