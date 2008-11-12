puts "***** #{File.basename(__FILE__)} ****"
# add_gem_path(File.expand_path(File.join(File.dirname(__FILE__), 'gems')))

require File.join(File.dirname(__FILE__), 'gems')
require 'haml'
require File.join(File.dirname(__FILE__), "mack-haml", 'haml_engine')
