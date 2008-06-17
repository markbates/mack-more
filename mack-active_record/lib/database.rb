module Mack
  module Database
    def self.establish_connection
      dbs = YAML::load(ERB.new(IO.read(File.join(Mack::Configuration.root, "config", "database.yml"))).result)
      ActiveRecord::Base.establish_connection(dbs[Mack::Configuration.env])
      # require File.join(File.dirname(__FILE__), "schema_info")
    end
  end
end