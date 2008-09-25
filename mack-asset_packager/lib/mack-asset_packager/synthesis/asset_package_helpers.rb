module Mack
  module ViewHelpers
    module AssetPackageHelpers
      include Mack::ViewHelpers::LinkHelpers
      
      def should_merge?
        Mack::AssetPackage.merge_environments.include?Mack.env
      end
      
      def javascripts_bundle(*sources)
        if sources.include?(:defaults)
          sources = sources[0..(sources.index(:defaults))] +
            assets.javascripts(:defaults) +
            sources[(sources.index(:defaults) + 1)..sources.length]
          sources.delete(:defaults)
        end
        
        sources.collect! { |s| s.to_s }
        sources = (should_merge? ?
          Mack::AssetPackage.targets_from_sources('javascripts', sources) :
          Mack::AssetPackage.sources_from_targets('javascripts', sources))
        
        sources.collect { |source| javascript(source) }.join("\n")
      end
      
      def stylesheets_bundle(*sources)
        options = sources.last.is_a?(Hash) ? sources.pop : { }
        
        if sources.include?(:defaults)
          sources = sources[0..(sources.index(:defaults))] +
            assets.stylesheets(:defaults) +
            sources[(sources.index(:defaults) + 1)..sources.length]
          sources.delete(:defaults)
        end
        
        sources.collect! { |s| s.to_s }
        sources = (should_merge? ?
          Mack::AssetPackage.targets_from_sources('stylesheets', sources) :
          Mack::AssetPackage.sources_from_targets('stylesheets', sources))
        
        sources.collect { |source| source = stylesheet(source, options) }.join("\n")    
      end
      
    end
  end
end
