require 'rubygems'
require 'digest'
require 'facets'
require 'facets/ruby'
require 'facets/style'
require 'facets/blank'
require 'facets/hash'
require 'facets/hash/symbolize_keys'
require 'facets/hash/stringify_keys'
require 'facets/module'
require 'facets/infinity'
require 'facets/times'
require 'english/inflect'
require 'english/numerals'
require 'extlib/assertions'
require 'extlib/hook'

fl = File.join(File.dirname(__FILE__), "mack-facets")

[:inflector, :inflections, :options_merger, :registry_list, :registry_map, :blank_slate].each do |k|
  path = File.join(fl, "utils", "#{k}")
  require path
end

[:array, :class, :hash, :kernel, :math, :module, :object, :string, :symbol, :nil_class].each do |k|
  path = File.join(fl, "extensions", "#{k}")
  require path
end

[:numerals, :inflect].each do |k|
  path = File.join(fl, "english_extensions", "#{k}")
  require path
end

