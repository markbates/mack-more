require 'mack-caching'
def undef_const(klass, k)
  klass.remove_const(k) if klass.const_defined?(k)
end

# There are several constants being redefined by unicodechars gem in
# the context of ActiveSupport.  So, if activesupport is in use
# then requiring unicodechars gem will result in a bunch of
# const redefined warning messages.
if Object.const_defined?("ActiveSupport")
  module ActiveSupport::Multibyte # :nodoc:
    class << self; public :remove_const; end
  end
 
  mod = ActiveSupport::Multibyte
  undef_const(mod, 'DEFAULT_NORMALIZATION_FORM')
  undef_const(mod, 'NORMALIZATIONS_FORMS')
  undef_const(mod, 'UNICODE_VERSION')
  
  module ActiveSupport::Multibyte # :nodoc:
    class << self; private :remove_const; end
  end

  module ActiveSupport::Multibyte::Handlers # :nodoc:
    class UTF8Handler # :nodoc:
      class << self
        public :remove_const
      end
    end
  end
  
  mod = ActiveSupport::Multibyte::Handlers::UTF8Handler
  undef_const(mod, "HANGUL_SBASE")
  undef_const(mod, "HANGUL_LBASE")
  undef_const(mod, "HANGUL_VBASE")
  undef_const(mod, "HANGUL_TBASE")
  undef_const(mod, "HANGUL_LCOUNT")
  undef_const(mod, "HANGUL_VCOUNT")
  undef_const(mod, "HANGUL_TCOUNT")
  undef_const(mod, "HANGUL_NCOUNT")
  undef_const(mod, "HANGUL_SCOUNT")
  undef_const(mod, "HANGUL_SLAST")
  undef_const(mod, "HANGUL_JAMO_FIRST")
  undef_const(mod, "HANGUL_JAMO_LAST")
  undef_const(mod, "UNICODE_WHITESPACE")
  undef_const(mod, "UNICODE_LEADERS_AND_TRAILERS")
  undef_const(mod, "UTF8_PAT")
  undef_const(mod, "UNICODE_TRAILERS_PAT")
  undef_const(mod, "UNICODE_LEADERS_PAT")
  
  module ActiveSupport::Multibyte::Handlers # :nodoc:
    class UTF8Handler # :nodoc:
      class << self
        
        remove_const('UCD') if const_defined?('UCD')
        
        private :remove_const
      end
    end
  end
  
end 

require 'unicodechars'
require 'yaml'

dir_globs = Dir.glob(File.join(File.dirname(__FILE__), "mack-localization", "**/*.rb"))
dir_globs.each do |d|
  require d
end


configatron.mack.localization.set_default(:base_language, 'en')
configatron.mack.localization.set_default(:supported_languages, %w{bp en fr it de es})
configatron.mack.localization.set_default(:char_encoding, 'us-ascii')
configatron.mack.localization.set_default(:dynamic_translation, false)
configatron.mack.localization.set_default(:base_directory, [Mack::Paths.app('lang')])
configatron.mack.localization.set_default(:content_expiry, 3600)
