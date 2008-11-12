puts "***** #{File.basename(__FILE__)} ****"
# add_gem_path(File.expand_path(File.join(File.dirname(__FILE__), 'gems')))

require File.join(File.dirname(__FILE__), 'gems')

require 'pdf/writer'
require File.join(File.dirname(__FILE__), "mack-pdf_writer", 'pdf_engine')
