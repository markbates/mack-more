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
        package = Mack::Assets::Package.new(files, asset_type)
        package.contents.each do |file|
          data_arr << self.send("old_#{asset_type}", file, options)
        end
        return data_arr.join("\n")
      end   

    end
  end
end
