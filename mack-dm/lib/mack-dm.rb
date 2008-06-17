require 'rubygems'
require 'genosaurus'

require 'dm-core'
require 'dm-validations'
require 'dm-migrations'

fl = File.join(File.dirname(__FILE__))

require File.join(fl, "database")
# require File.join(fl, "helpers", "orm_helpers")
# 
# [:migration, :model, :scaffold].each do |gen|
#   require File.join(fl, "#{gen}_generator", "#{gen}_generator")
# end 

DataMapper.logger = Mack.logger

Mack::Database.establish_connection(Mack::Configuration.env)