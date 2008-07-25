module Mack
  module Localization # :nodoc:
    class ContentCache < Cachetastic::Caches::Base
    end
  end
end

class Object
  def l10n_cache
    Mack::Localization::ContentCache
  end
end
