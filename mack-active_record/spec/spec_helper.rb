require 'rubygems'
require 'pathname'
require 'spec'
require 'mack_ruby_core_extensions'

module Mack
  
  def self.root
    File.join(File.dirname(__FILE__), "tmp")
  end
  
  def self.env
    "test"
  end
  
end

class ViewTemplate
  
  attr_accessor :options
  
  def initialize(options = {})
    self.options = options
  end
  
  def method_missing(sym, *args)
    puts "self.options[:locals]: #{self.options[:locals].inspect}"
    if self.options[:locals]
      puts "self.options[:locals][#{sym}]: #{self.options[:locals][sym].inspect}"
      return self.options[:locals][sym]
    end
    raise NoMethodError.new(sym.to_s)
  end
  
  def binder
    binding
  end
  
  def pluralize_word(count, word)
    if count.to_i == 1
      "#{count} #{word.singular}"
    else
      "#{count} #{word.plural}"
    end
  end
  
end

def render(type, value, options)
  vt = ViewTemplate.new(options)
  case type.to_sym
  when :partial
  when :inline
    ERB.new(value).result(vt.binder)
  end
end

def database_yml
  %{
test:
  adapter: sqlite3
  database: <%= File.join(Mack.root, "mack-active_record_test.db") %>
  }
end

def write_database_yml
  File.open(File.join(configuration_directory, "database.yml"), "w") do |f|
    f.puts database_yml
  end
end

def configuration_directory
  cd = File.join(Mack.root, "config")
  FileUtils.mkdir_p(cd)
  cd
end

require Pathname(__FILE__).dirname.parent.expand_path + 'lib/mack-active_record'