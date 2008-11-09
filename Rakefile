require File.join(File.dirname(__FILE__), "common_rake_tasks", "rake_task_requires")
GEMS = full_gem_list

namespace :install do
  
  desc "Installs all the mack-more gems"
  task :all do
    GEMS.each do |gem|
      sh("cd mack-#{gem} && rake install --trace")
    end
  end
  
  GEMS.each do |gem|
    desc "Installs the mack-#{gem} gem."
    task "#{gem}" do
      sh("cd mack-#{gem} && rake install --trace")
    end
  end
  
end

namespace :freeze do
  
  desc "Installs all the mack-more gems"
  task :all do
    GEMS.each do |gem|
      sh("cd mack-#{gem} && rake gem:package:freezer")
    end
  end
  
  GEMS.each do |gem|
    desc "Installs the mack-#{gem} gem."
    task "#{gem}" do
      sh("cd mack-#{gem} && rake gem:package:freezer")
    end
  end
  
end

namespace :rdoc do
  
  desc "Runs RDoc on all the mack-more gems."
  task :all do
    GEMS.each do |gem|
      sh("cd mack-#{gem} && rake rerdoc")
    end
  end
  
  task :destroy do
    GEMS.each do |gem|
      sh("cd mack-#{gem} && rm -rf doc")
    end
  end
  
  GEMS.each do |gem|
    desc "Runs RDoc on the mack-#{gem} gem."
    task "#{gem}" do
      sh("cd mack-#{gem} && rake rerdoc")
    end
  end
  
  desc "Compiles all the RDoc for all the mack-more gems into the mack-more/doc directory."
  task :integrated do
    sh("rdoc --force --line-numbers --inline-source --exclude spec --exclude example --exclude common_rake_tasks --title 'mack-more' --op mack-more/doc")
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
  
  desc "Runs the test suite on all the mack-more gems."
  task :all do
    GEMS.each do |gem|
      sh("cd mack-#{gem} && rake")
    end
  end
  
  GEMS.each do |gem|
    desc "Runs the test suite for the mack-#{gem} gem."
    task "#{gem}" do
      sh("cd mack-#{gem} && rake")
    end
  end
  
end

desc "Runs the test suite on all the mack-more gems."
task :default => "test:all"

desc "Installs all the mack-more gems"
task :install => "install:all"

desc "Runs RDoc on all the mack-more gems."
task :rdoc => "rdoc:all"

desc "Remove doc folder for all mack-more gems"
task :destroy_rdoc => "rdoc:destroy"

GEMS.each do |gem|
  desc "Runs the test suite for the mack-#{gem} gem."
  task gem => "test:#{gem}"
end