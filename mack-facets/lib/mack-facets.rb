puts "***** #{File.basename(__FILE__)} ****"
add_gem_path(File.expand_path(File.join(File.dirname(__FILE__), 'gems')))

fl = File.join(File.dirname(__FILE__), "mack-facets")
# require 'rubygems'
require 'digest'
require File.join(fl, "extensions", "time") # we need this here, otherwise facets 2.4.3 breaks!
require 'facets'
require 'facets/string'
require 'facets/blank'
require 'facets/hash'
require 'facets/hash/symbolize_keys'
require 'facets/hash/stringify_keys'
require 'facets/module'
require 'facets/infinity'
require 'facets/times'
require 'facets/time'
require 'facets/string/style'
require 'english/inflect'
require 'english/numerals'
require 'extlib/assertions'
require 'extlib/hook'

[:inflector, :inflections, :options_merger, :registry_list, :registry_map, :blank_slate].each do |k|
  path = File.join(fl, "utils", "#{k}")
  require path
end

[:array, :class, :hash, :kernel, :math, :module, :object, :string, :symbol, :nil_class, :date_time, :file].each do |k|
  path = File.join(fl, "extensions", "#{k}")
  require path
end

[:numerals, :inflect].each do |k|
  path = File.join(fl, "english_extensions", "#{k}")
  require path
end

