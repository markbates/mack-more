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
require 'english/inflect'
require 'english/numerals'
[:inflector, :inflections, :options_merger].each do |k|
  require "utils/#{k}"
end

[:array, :class, :hash, :kernel, :math, :module, :object, :string, :symbol].each do |k|
  require "extensions/#{k}"
end

[:numerals, :inflect].each do |k|
  require "english_extensions/#{k}"
end