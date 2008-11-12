path = File.expand_path(File.join(File.dirname(__FILE__), 'gems'))
Gem.set_paths(path)

Dir.glob(File.join(path, '*')).each do |p|
  $:.unshift(File.join(p, 'lib'))

  full_gem_name = File.basename(p)
  version = full_gem_name.match(/([\d\.?]+)/).to_s
  gem_name = full_gem_name.gsub("-#{version}", '')
  
  if gem_name == 'facets'
    $:.unshift(File.expand_path(File.join(p, 'lib', 'core')))
    $:.unshift(File.expand_path(File.join(p, 'lib', 'more')))
    $:.unshift(File.expand_path(File.join(p, 'lib', 'lore')))
  end
  
  begin
    gem gem_name, ">= #{version}"
  rescue Gem::LoadError 
  end
end


# Dir.glob(File.join(File.dirname(__FILE__), 'gems', '*')).each do |path|
#   full_gem_name = File.basename(path)
#   version = full_gem_name.match(/([\d\.?]+)/).to_s
#   gem_name = full_gem_name.gsub("-#{version}", '')
#   begin
#     gem gem_name, ">= #{version}"
#   rescue Gem::LoadError
#     path = File.expand_path(File.join(File.dirname(__FILE__), 'gems'))
#     Gem.set_paths(path)
#     $:.unshift(File.join(path, full_gem_name, 'lib'))
#     if gem_name == 'facets'
#       $:.unshift(File.expand_path(File.join(path, full_gem_name, 'lib', 'core')))
#       $:.unshift(File.expand_path(File.join(path, full_gem_name, 'lib', 'more')))
#       $:.unshift(File.expand_path(File.join(path, full_gem_name, 'lib', 'lore')))
#     end
#   end
# end