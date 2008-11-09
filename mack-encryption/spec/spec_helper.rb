module Mack
  VERSION = 'testing'
end

# require 'rubygems'
gem 'rspec'
require 'spec'
require 'mack-facets'
require 'configatron'
require File.join(File.dirname(__FILE__), "..", "lib", "mack-encryption")

module Mack
  module Utils
    module Crypt
      class ReverseWorker
        
        def encrypt(x)
          x.reverse
        end
        
        def decrypt(x)
          x.reverse
        end
        
      end
    end
  end
end
