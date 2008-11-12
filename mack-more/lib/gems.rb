Dir.glob(File.join(File.dirname(__FILE__), 'gems', '*')).each do |path|
  full_gem_name = File.basename(path)
  version = full_gem_name.match(/([\d\.?]+)/).to_s
  gem_name = full_gem_name.gsub("-#{version}", '')
  begin
    gem gem_name, ">= #{version}"
  rescue Gem::LoadError
    $:.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'gems', full_gem_name, 'lib')))
  end
end