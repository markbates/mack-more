require 'rubygems'
require 'genosaurus'

require 'activerecord'

fl = File.join(File.dirname(__FILE__))

require File.join(fl, "database")
require File.join(fl, "helpers", "orm_helpers")
