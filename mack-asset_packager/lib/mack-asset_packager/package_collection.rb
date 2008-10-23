module Mack
  module Assets
    class PackageCollection # :nodoc:
      include Singleton
      ASSET_LOAD_TIME = Time.now
      
      attr_accessor :bundle_processed
      
      def merge?
        return configatron.mack.assets.enable_bundle_merge
      end
      
      def initialized
        self.bundle_processed = false
      end
      
      def destroy_compressed_bundles
        assets_mgr.groups_by_asset_type(:javascripts).each do |group|
          path = Mack::Paths.javascripts(group + ".js")
          if File.exists?(path)
            FileUtils.rm(path)
          end
        end
        assets_mgr.groups_by_asset_type(:stylesheets).each do |group|
          path = Mack::Paths.stylesheets(group + ".css")
          if File.exists?(path)
            FileUtils.rm(path)
          end
        end
      end
      
      def compress_bundles
        if !self.bundle_processed and merge?
          self.bundle_processed = true
          assets_mgr.groups_by_asset_type(:javascripts).each do |group|
            compress(group, :javascripts)
          end
          
          assets_mgr.groups_by_asset_type(:stylesheets).each do |group|
            compress(group, :stylesheets)
          end
        end
      end
      
      def extension(asset_type)
        return "js" if asset_type.to_s == "javascripts"
        return "css" if asset_type.to_s == "stylesheets"
        return ""
      end
      
      private
      def compress(group, asset_type)
        base_dir  = Mack::Paths.public(asset_type)
        file_name = "#{group}.#{extension(asset_type)}"
        file_path = File.join(base_dir, file_name)
        
        # check if we need to delete the existing file.
        delete_file(file_path, true)
        
        # if the file still exists, that means it's not time to expire the previously compressed doc
        # just return the file_name
        return file_name if File.exists?(file_path)
        
        # now read data from all the files defined in the bundle
        raw = ""
        assets_mgr.send(asset_type, group).each do |file|
          
          Mack.search_path_local_first(:public).each do |p|
            path = File.join(p, asset_type.to_s, file)
            if File.exists?(path)
              raw += File.read(path)
              break
            end
          end
        end
        
        # save it to some tmp file, and compress it
        jsmin_path = File.join(File.dirname(__FILE__), "jsmin.rb")
        tmp_file = File.join(base_dir, "#{asset_type}_#{rand(10000)}")
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