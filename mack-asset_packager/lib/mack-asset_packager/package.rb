module Mack
  module Assets
    #
    # This class represent the 'package' for the application's asset files.
    # The responsibility of this class is to package up all the asset files
    # into one asset file so the application can use 1 instead of 10 different 
    # asset files. The packaging/compression will only happen if and only if
    # configatron.mack.asset_packager.disable_bundle_merge is not set and the
    # app is running in production mode.
    #
    class Package
      ASSET_LOAD_TIME = Time.now
      
      attr_accessor :files
      attr_accessor :asset_type
      
      # 
      # Should we merge the asset bundle into 1 asset file?
      # Yes, only if configatron.mack.asset_packager.disable_bundle_merge is not set,
      # and environment is production.
      #
      def merge?
        if Mack.env == "production"
          return true if !configatron.mack.asset_packager.disable_bundle_merge
        end
        return false
      end
      
      def initialize(list, type) # :nodoc:
        self.files = list
        self.asset_type = type
      end
      
      # 
      # Return a list of asset files (this is so the caller can generate
      # proper asset tag--e.g. javascript/css tag).
      #
      # Calling this method will result in the merge and compression
      # of the asset files (if merge? is true).  
      #
      # The previously compressed/merged file will be deleted once 
      # per application's life time.
      #
      def contents
        return [self.files].flatten if !merge?
        self.files = self.files.collect {|s| s.to_s}
        processed_files = []
        
        # find all bundled files listed in the file_list
        groups = assets_mgr.groups_by_asset_type(self.asset_type)
        groups.each do |group|
          if self.files.include?(group.to_s)
            processed_files << compress_bundle(group.to_s)
            self.files.delete(group.to_s)
          end
        end
        
        # now for all files that's not part of the bundle
        # just add them to the list
        processed_files += self.files
        return processed_files
      end
      
      private    
          
      def extension
        return "js" if self.asset_type == "javascripts"
        return "css" if self.asset_type == "stylesheets"
        return ""
      end
      
      def compress_bundle(group)
        base_dir  = Mack::Paths.public(self.asset_type)
        file_name = "#{group}.#{extension}"
        file_path = File.join(base_dir, file_name)
        
        # check if we need to delete the existing file.
        delete_file(file_path, true)
        
        # if the file still exists, that means it's not time to expire the previously compressed doc
        # just return the file_name
        return file_name if File.exists?(file_path)
        
        # now read data from all the files defined in the bundle
        raw = ""
        assets_mgr.send(self.asset_type, group).each do |file|
          path = File.join(base_dir, file)
          raw += File.read(path)
        end
        
        # save it to some tmp file, and compress it
        jsmin_path = File.join(File.dirname(__FILE__), "jsmin.rb")
        tmp_file = File.join(base_dir, "#{self.asset_type}_#{rand(10000)}")
        File.open(tmp_file, "w") { |f| f.write(raw) }
        if asset_type.to_s == "javascripts"
          `ruby #{jsmin_path} < #{tmp_file} > #{file_path} \n`
        elsif asset_type.to_s == "stylesheets"
          min_data = CSSMin.new(raw).minimize
          File.open(file_path, "w") { |f| f.write(min_data) }
        end
        # now that we're done, let's delete the tmp file
        delete_file(tmp_file)
        
        return file_name
      end
      
      def delete_file(name, check_time = false)
        begin
          FileUtils.rm(name) if !check_time or (check_time and File.ctime(name) < ASSET_LOAD_TIME)
        rescue Exception => ex
        end
      end
      
    end
  end
end
