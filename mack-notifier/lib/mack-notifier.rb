require File.join(File.dirname(__FILE__), 'gems')
require 'validatable'
require 'tmail'
require 'xmpp4r-simple'

fl = File.join(File.dirname(__FILE__), "mack-notifier")

require File.join(fl, "paths")
require File.join(fl, "settings")
require File.join(fl, "errors")
require File.join(fl, "attachment")
require File.join(fl, "notifier_generator", "notifier_generator")

[:delivery_handlers, :adapters, :rendering].each do |dir|
  Dir.glob(File.join(fl, dir.to_s, "**/*.rb")).each do |h|
    require h
  end
end

require File.join(fl, "notifier")

require File.join(fl, "validations")

require File.join(fl, "testing")

require File.join(fl, "loader")
