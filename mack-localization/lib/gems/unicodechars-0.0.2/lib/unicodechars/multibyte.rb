$KCODE = "UTF8"

module ActiveSupport
  module Multibyte
    DEFAULT_NORMALIZATION_FORM = :kc
    NORMALIZATIONS_FORMS = [:c, :kc, :d, :kd]
    UNICODE_VERSION = '5.0.0'
  end
end

require File.join(File.dirname(__FILE__), "multibyte", "chars")

module Kernel
  def u(str)
    ActiveSupport::Multibyte::Chars.new(str)
  end
end

class String
  def chars
    u(self)
  end
end