require 'tmail'
require File.join(File.dirname(__FILE__), "paths")
require File.join(File.dirname(__FILE__), "settings")
require File.join(File.dirname(__FILE__), "errors")
require File.join(File.dirname(__FILE__), "attachment")
require File.join(File.dirname(__FILE__), "mailer_generator", "mailer_generator")

[:delivery_handlers, :adapters, :rendering].each do |dir|
  Dir.glob(File.join(File.dirname(__FILE__), dir.to_s, "**/*.rb")).each do |h|
    require h
  end
end

require File.join(File.dirname(__FILE__), "mailer")

require File.join(File.dirname(__FILE__), "validatable")

require File.join(File.dirname(__FILE__), "testing")

require File.join(File.dirname(__FILE__), "loader")