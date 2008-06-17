require File.dirname(__FILE__) + '/../test_helper.rb'

class GlobalAccessorTest < Test::Unit::TestCase
  def test_object_level_methods
    assert self.respond_to?(:l10n_formatter)
    assert self.respond_to?(:l10n_translator)
  end  
end