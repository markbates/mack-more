require File.join(File.dirname(__FILE__), "common_rake_tasks", "rake_task_requires")
GEMS = full_gem_list

namespace :install do
  
  task :all do
    GEMS.each do |gem|
      sh("cd mack-#{gem} && rake install")
    end
  end
  
  GEMS.each do |gem|
    task "#{gem}" do
      sh("cd mack-#{gem} && rake install")
    end
  end
  
end

namespace :rdoc do
  
  task :all do
    GEMS.each do |gem|
      sh("cd mack-#{gem} && rake rerdoc")
    end
  end
  
  GEMS.each do |gem|
    task "#{gem}" do
      sh("cd mack-#{gem} && rake rerdoc")
    end
  end
  
  task :integrated do
    sh("rdoc --force --line-numbers --inline-source --exclude spec --exclude example --exclude common_rake_tasks --title 'mack-more'")
  end
  
end

namespace :release do
  
  task :all do
    GEMS.each do |gem|
      sh("cd mack-#{gem} && rake release")
    end
  end
  
  GEMS.each do |gem|
    task "#{gem}" do
      sh("cd mack-#{gem} && rake release")
    end
  end
  
end

namespace :test do
  
  task :all do
    GEMS.each do |gem|
      sh("cd mack-#{gem} && rake")
    end
  end
  
  GEMS.each do |gem|
    task "#{gem}" do
      sh("cd mack-#{gem} && rake")
    end
  end
  
end

task :default => "test:all"