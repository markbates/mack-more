module Mack
  module ViewHelpers
    module LinkHelpers # :nodoc:
      alias_method :old_javascripts, :javascript
      alias_method :old_stylesheets, :stylesheet

      def javascript(files, options = {})
        process_file(files, 'javascripts', options)
      end

      def stylesheet(files, options = {})
        process_file(files, 'stylesheets', options)
      end

      private
      def process_file(files, asset_type, options)
        files = [files].flatten
        data_arr = []
        contents(files, asset_type).each do |file|
          data_arr << self.send("old_#{asset_type}", file, options)
        end
        return data_arr.join("\n")
      end   
      
      def contents(files, asset_type)
        return [files].flatten if !Mack::Assets::PackageCollection.instance.merge?
        files = files.collect {|s| s.to_s}
        processed_files = []
        
        # Ask the package_collection to compress the bundles.
        # the package_collection will only perform the compression once
        Mack::Assets::PackageCollection.instance.compress_bundles
        
        # find all bundled files listed in the file_list
        groups = assets_mgr.groups_by_asset_type(asset_type)
        groups.each do |group|
          if files.include?(group.to_s)
            processed_files << "#{group.to_s}.#{Mack::Assets::PackageCollection.instance.extension(asset_type)}"
            files.delete(group.to_s)
          end
        end
        
        # now for all files that's not part of the bundle
        # just add them to the list
        processed_files += files
        return processed_files
      end

    end
  end
end
