module Mack
  module Database
    module Migrations
      
      def self.migrate
        # raise NoMethodError.new(:migrate)
      end
      
      def self.rollback(step)
        # raise NoMethodError.new(:rollback)
      end
      
      def self.abort_if_pending_migrations
        # raise NoMethodError.new(:abort_if_pending_migrations)
      end
      
    end # Migrations
  end # Database
end # Mack