require File.dirname(__FILE__) + '/../test_helper.rb'

class MultibyteTest < Test::Unit::TestCase
  
  def test_ruby_unicode
    a = "çã"
    # ruby < 1.9 doesn't have unicode support
    assert a.size != 2
  end
  
  def test_unicode_support
    a = u("çã")
    assert a.size == 2
    assert a.reverse == "ãç"
  end
end