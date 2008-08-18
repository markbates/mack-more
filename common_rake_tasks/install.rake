desc "Install the gem"
task :install => [:rerdoc, :package] do |t|
  puts `sudo gem install --local pkg/#{@gem_spec.name}-#{@gem_spec.version}.gem --no-update-sources`
end