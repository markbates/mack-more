module Mack
  class AssetPackage

    # class variables  
    # singleton methods
    class << self
      
      def merge_environments=(environments)
        @@merge_environments = environments
      end
      
      def merge_environments
        @@merge_environments ||= ["production"]
      end
      
      def parse_path(path)
        /^(?:(.*)\/)?([^\/]+)$/.match(path).to_a
      end

      def find_by_target(asset_type, target)
        package_hash = { target => assets.send(asset_type, target) }
        package_hash = nil if !package_hash[target] or package_hash[target].empty?
        package_hash ? self.new(asset_type, package_hash) : nil
      end
      
      def find_by_source(asset_type, source)
        file_name = File.basename(source.to_s)
        ext = asset_type == 'javascripts' ? '.js' : '.css'
        file_name += ext if !file_name.end_with?(ext)
        
        package_hash = nil
        assets.groups.each do |g|
          arr = assets.send(asset_type, g)
          package_hash = { g => arr } if arr.include?(file_name)
        end
        
        package_hash ? self.new(asset_type, package_hash) : nil
      end

      def targets_from_sources(asset_type, sources)
        package_names = Array.new
        sources.each do |source|
          package = find_by_target(asset_type, source) || find_by_source(asset_type, source)
          package_names << (package ? package.current_file : source)
        end
        package_names.uniq
      end

      def sources_from_targets(asset_type, targets)
        source_names = Array.new
        targets.each do |target|
          package = find_by_target(asset_type, target)
          source_names += (package ? package.sources.collect do |src|
            package.target_dir.gsub(/^(.+)$/, '\1/') + src
          end : target.to_a)
        end
        source_names.uniq
      end

      def build_all
        assets.groups.each do |group|
          package_hash = {group => assets.javascripts(group)}
          self.new('javascripts', package_hash).build if !package_hash[group].empty?
          package_hash = {group => assets.stylesheets(group)}
          self.new('stylesheets', package_hash).build if !package_hash[group].empty?
        end
      end

      def delete_all
        assets.groups.each do |group|
          package_hash = {group => assets.javascripts(group)}
          self.new('javascripts', package_hash).delete_all_builds
          package_hash = {group => assets.stylesheets(group)}
          self.new('stylesheets', package_hash).delete_all_builds
        end
      end
    end
    
    # instance methods
    attr_accessor :asset_type, :target, :target_dir, :sources
  
    def initialize(asset_type, package_hash)
      target_parts = self.class.parse_path(package_hash.keys.first.to_s)
      @target_dir = target_parts[1].to_s
      @target = target_parts[2].to_s
      @sources = package_hash[package_hash.keys.first]
      @asset_type = asset_type
      @asset_path = ($asset_base_path ? "#{$asset_base_path}/" : "#{Mack.root}/public/") +
          "#{@asset_type}#{@target_dir.gsub(/^(.+)$/, '/\1')}"
      @extension = get_extension
      @match_regex = Regexp.new("\\A#{@target}_\\d+.#{@extension}\\z")
    end
  
    def current_file
      @target_dir.gsub(/^(.+)$/, '\1/') +
          Dir.new(@asset_path).entries.delete_if { |x| ! (x =~ @match_regex) }.sort.reverse[0].chomp(".#{@extension}")
    end

    def build
      delete_old_builds
      create_new_build
    end
  
    def delete_old_builds
      Dir.new(@asset_path).entries.delete_if { |x| ! (x =~ @match_regex) }.each do |x|
        File.delete("#{@asset_path}/#{x}") unless x.index(revision.to_s)
      end
    end

    def delete_all_builds
      Dir.new(@asset_path).entries.delete_if { |x| ! (x =~ @match_regex) }.each do |x|
        File.delete("#{@asset_path}/#{x}")
      end
    end

    private
      def revision
        unless @revision
          revisions = [1]
          @sources.each do |source|
            revisions << get_file_revision("#{@asset_path}/#{source}.#{@extension}")
          end
          @revision = revisions.max
        end
        @revision
      end
  
      def get_file_revision(path)
        if File.exists?(path)
          begin
            `svn info #{path}`[/Last Changed Rev: (.*?)\n/][/(\d+)/].to_i
          rescue # use filename timestamp if not in subversion
            File.mtime(path).to_i
          end
        else
          0
        end
      end

      def create_new_build
        if File.exists?("#{@asset_path}/#{@target}_#{revision}.#{@extension}")
          log "Latest version already exists: #{@asset_path}/#{@target}_#{revision}.#{@extension}"
        else
          File.open("#{@asset_path}/#{@target}_#{revision}.#{@extension}", "w") {|f| f.write(compressed_file) }
          log "Created #{@asset_path}/#{@target}_#{revision}.#{@extension}"
        end
      end

      def merged_file
        merged_file = ""
        @sources.each do |s| 
          full_file_path = "#{@asset_path}/#{s}"
          full_file_path += ".#{@extension}" if !full_file_path.end_with?(@extension)
          File.open(full_file_path, "r") { |f| 
            merged_file += f.read + "\n" 
          }
        end
        merged_file
      end
    
      def compressed_file
        case @asset_type
          when "javascripts" then compress_js(merged_file)
          when "stylesheets" then compress_css(merged_file)
        end
      end

      def compress_js(source)
        jsmin_path = File.join(File.dirname(__FILE__), "..")
        tmp_path = "#{Mack.root}/tmp/#{@target}_#{revision}"
      
        # write out to a temp file
        File.open("#{tmp_path}_uncompressed.js", "w") {|f| f.write(source) }
      
        # compress file with JSMin library
        `ruby #{jsmin_path}/jsmin.rb <#{tmp_path}_uncompressed.js >#{tmp_path}_compressed.js \n`

        # read it back in and trim it
        result = ""
        File.open("#{tmp_path}_compressed.js", "r") { |f| result += f.read.strip }
  
        # delete temp files if they exist
        File.delete("#{tmp_path}_uncompressed.js") if File.exists?("#{tmp_path}_uncompressed.js")
        File.delete("#{tmp_path}_compressed.js") if File.exists?("#{tmp_path}_compressed.js")

        result
      end
  
      def compress_css(source)
        source.gsub!(/\s+/, " ")           # collapse space
        source.gsub!(/\/\*(.*?)\*\/ /, "") # remove comments - caution, might want to remove this if using css hacks
        source.gsub!(/\} /, "}\n")         # add line breaks
        source.gsub!(/\n$/, "")            # remove last break
        source.gsub!(/ \{ /, " {")         # trim inside brackets
        source.gsub!(/; \}/, "}")          # trim inside brackets
        source
      end

      def get_extension
        case @asset_type
          when "javascripts" then "js"
          when "stylesheets" then "css"
        end
      end
      
      def log(message)
        self.class.log(message)
      end
      
      def self.log(message)
        puts message
      end

      def self.build_file_list(path, extension)
        re = Regexp.new(".#{extension}\\z")
        file_list = Dir.new(path).entries.delete_if { |x| ! (x =~ re) }.map {|x| x.chomp(".#{extension}")}
        # reverse javascript entries so prototype comes first on a base rails app
        file_list.reverse! if extension == "js"
        file_list
      end
   
  end
end
