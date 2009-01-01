desc "Install the gem"
task :install => [:clean_rdoc, :package] do |t|
  sudo = ENV['SUDOLESS'] == 'true' || RUBY_PLATFORM =~ /win32|cygwin/ ? '' : 'sudo'
  puts `#{sudo} gem install #{File.join("pkg", @gem_spec.name)}-#{@gem_spec.version}.gem --no-update-sources --no-ri --no-rdoc`
end

namespace :multiruby do
  
  desc "Install the gem into multiruby"
  task :install => [:clean_rdoc, :package] do |t|
    sudo = ENV['SUDOLESS'] == 'true' || RUBY_PLATFORM =~ /win32|cygwin/ ? '' : 'sudo'
    puts `multiruby -S gem install #{File.join("pkg", @gem_spec.name)}-#{@gem_spec.version}.gem --no-update-sources --no-ri --no-rdoc`
  end

end