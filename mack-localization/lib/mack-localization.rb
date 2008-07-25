require 'unicodechars'
require 'yaml'

dir_globs = Dir.glob(File.join(File.dirname(__FILE__), "mack-localization", "**/*.rb"))
dir_globs.each do |d|
  require d
end
