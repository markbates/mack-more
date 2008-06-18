require 'rubygems'
require 'pathname'
require 'spec'

require File.join(File.dirname(__FILE__), "..", "lib", "mack-facets")

class Fruit
  
  def get_citrus
    Citrus.new
  end
  
end

class Citrus < Fruit
  
  def get_orange
    Orange.new
  end
  
end

class Orange < Citrus
  
  def add(x, y)
    ivar_cache("results") do
      x + y
    end
  end
  
  def say_hi(message)
    ivar_cache do
      message
    end
  end
  
  def to_s
    "I'm an Orange"
  end
  
end

module Animals
  class Dog
    class Poodle
    end
  end
end

class FauxLogger
  
  def initialize
    @messages = {:error => [], :warn => [], :fatal => [], :info => [], :debug => []}
  end
  
  def method_missing(sym, *args)
    @messages[sym] << args.parse_splat_args
  end
  
  def messages
    @messages
  end
  
end

class Route
  
  def initialize
    @routes = []
  end
  
  def add(options = {})
    @routes << options
  end
  
  def list
    @routes
  end
  
end