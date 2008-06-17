require 'rubygems'
require 'genosaurus'

require 'activerecord'

fl = File.join(File.dirname(__FILE__))

require File.join(fl, "database")
require File.join(fl, "helpers", "orm_helpers")

[:migration, :model, :scaffold].each do |gen|
  require File.join(fl, "#{gen}_generator", "#{gen}_generator")
end

Mack::Database.establish_connection