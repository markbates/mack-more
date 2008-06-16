module Mack
  module Database
    def self.establish_connection
      dbs = YAML::load(ERB.new(IO.read(File.join(Mack.root, "config", "database.yml"))).result)
      ActiveRecord::Base.establish_connection(dbs[Mack.env])
      require File.join(File.dirname(__FILE__), "schema_info")
    end
  end
end