puts "***** #{File.basename(__FILE__)} ****"
add_gem_path(File.expand_path(File.join(File.dirname(__FILE__), 'gems')))

require 'singleton'
require 'ezcrypto'

base = File.join(File.dirname(__FILE__), "mack-encryption")

Dir.glob(File.join(base, "**/*.rb")).each do |f|
  require f
end