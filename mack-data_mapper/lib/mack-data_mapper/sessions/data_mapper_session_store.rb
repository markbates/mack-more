module Mack
  module SessionStore # :nodoc:
    # Stores session information in the database.
    # To set the expiry time for this session store use the following app_config setting:
    #   data_mapper_session_store::expiry_time: <%= 4.hours %>
    class DataMapper < Mack::SessionStore::Base

      class << self
    
        # Gets the session from the db, using the specified id.
        # If the session has 'expired' then it's deleted from the db.
        def get(id, *args)
          create_storage_if_non_existent
          sess = Mack::DataMapper::Session.first(:id => id)
          return nil if sess.nil? 
          expire_date = DateTime.now.minus_seconds(app_config.data_mapper_session_store.expiry_time)
          if sess.updated_at.to_s < expire_date.to_s
            sess.destroy
            return nil
          end
          return sess.data
        end
        
        # Creates or updates the session in the db.
        def set(id, request, *args)
          create_storage_if_non_existent
          sess = Mack::DataMapper::Session.get(id)
          if sess.nil?
            sess = Mack::DataMapper::Session.new(:id => id, :data => request.session)
            raise sess.errors.full_messages.inspect unless sess.valid?
            sess.save
          else
            sess.data = request.session
            sess.save
          end
        end
        
        # Deletes the session from the db, if it exists.
        def expire(id, *args)
          create_storage_if_non_existent
          sess = Mack::DataMapper::Session.get(id)
          sess.destroy unless sess.nil?
        end
        
        # Deletes all the sessions from the db.
        def expire_all(*args)
          create_storage_if_non_existent
          Mack::DataMapper::Session.all.destroy!
        end
        
        private
        def create_storage_if_non_existent
          unless Mack::DataMapper::Session.storage_exists?
            Mack::DataMapper::Session.auto_migrate!
          end
        end
      
      end
      
    end # DataMapper
  end # SessionStore
end # Mack