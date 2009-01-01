module Gem
  class << self
    public :set_paths
  end
end
path = File.expand_path(File.join(File.dirname(__FILE__), 'gems'))
Gem.set_paths(path)

Dir.glob(File.join(path, '*')).each do |p|
  full_gem_name = File.basename(p)
  version = full_gem_name.match(/([\d\.?]+)/).to_s
  gem_name = full_gem_name.gsub("-#{version}", '')
  
  $:.unshift(File.join(p, 'lib'))
  if gem_name == 'facets'
    $:.unshift(File.expand_path(File.join(p, 'lib', 'core')))
    $:.unshift(File.expand_path(File.join(p, 'lib', 'more')))
    $:.unshift(File.expand_path(File.join(p, 'lib', 'lore')))
  end
  
  begin
    if RUBY_VERSION >= '1.9.1'
      gem gem_name
    else
      gem gem_name, ">= #{version}"
    end
  rescue Gem::LoadError 
  end
end