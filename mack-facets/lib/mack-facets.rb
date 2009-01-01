require File.join(File.dirname(__FILE__), 'gems')

fl = File.join(File.dirname(__FILE__), "mack-facets")
require 'digest'
require 'active_support'
require 'english/inflect'
require 'english/numerals'
require 'extlib/assertions'
require 'extlib/hook'
require 'extlib/inflection'

[:inflector, :inflections, :options_merger, :registry_list, :registry_map, :blank_slate].each do |k|
  path = File.join(fl, "utils", "#{k}")
  require path
end

[:array, :class, :duration, :hash, :kernel, :math, :module, :object, :string, :symbol, :nil_class, :date_time, :file, :time].each do |k|
  path = File.join(fl, "extensions", "#{k}")
  require path
end

[:numerals, :inflect].each do |k|
  path = File.join(fl, "english_extensions", "#{k}")
  require path
end

