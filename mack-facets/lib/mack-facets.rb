module Kernel
  
  def v1_8?
    RUBY_VERSION >= '1.8.0' && RUBY_VERSION < '1.9.0'
  end
  
  def v1_9?
    RUBY_VERSION >= '1.9.0' && RUBY_VERSION < '2.0.0'
  end
  
end

require File.join(File.dirname(__FILE__), 'gems')

fl = File.join(File.dirname(__FILE__), "mack-facets")

if v1_9?
  $:.unshift(File.expand_path(File.join(fl, '1_9')))
end

require 'digest'
require 'active_support'
require 'english/inflect'
require 'english/numerals'
require 'extlib/assertions'
require 'extlib/hook'
require 'extlib/inflection'

[:inflector, :inflections, :options_merger, :registry_list, :registry_map, :method_list].each do |k|
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

