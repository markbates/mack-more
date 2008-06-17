require 'rake'

GEMS = %w{active_record dm}

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

# namespace :release do
#   
#   task :all do
#     GEMS.each do |gem|
#       sh("cd mack-#{gem} && rake release")
#     end
#   end
#   
#   GEMS.each do |gem|
#     task "#{gem}" do
#       sh("cd mack-#{gem} && rake release")
#     end
#   end
#   
# end

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