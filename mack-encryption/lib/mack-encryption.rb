require 'singleton'

require File.join(File.dirname(__FILE__), 'gems')

require 'ezcrypto'

base = File.join(File.dirname(__FILE__), "mack-encryption")

Dir.glob(File.join(base, "**/*.rb")).each do |f|
  require f
end