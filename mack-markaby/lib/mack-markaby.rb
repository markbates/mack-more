puts "***** #{File.basename(__FILE__)} ****"
add_gem_path(File.expand_path(File.join(File.dirname(__FILE__), 'gems')))

require 'markaby'
require File.join(File.dirname(__FILE__), "mack-markaby", 'markaby_engine')
