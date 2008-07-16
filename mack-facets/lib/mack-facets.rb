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
require 'english/inflect'
require 'english/numerals'
[:inflector, :inflections, :options_merger, :hookable].each do |k|
  path = File.join File.dirname(__FILE__), "utils", "#{k}"
  #puts "requiring #{path}"
  require path
end

[:array, :class, :hash, :kernel, :math, :module, :object, :string, :symbol].each do |k|
  path = File.join File.dirname(__FILE__), "extensions", "#{k}"
  #puts "requiring #{path}"
  require path
end

[:numerals, :inflect].each do |k|
  path = File.join File.dirname(__FILE__), "english_extensions", "#{k}"
  #puts "requiring #{path}"
  require path
end

