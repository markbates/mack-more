require File.dirname(__FILE__) + '/../test_helper.rb'

class TranslatorTest < Test::Unit::TestCase

  def test_get_key_en
    key = :sale
    str = l10n_translator.gets(:items, key, :en)
    assert str == "This application is for sale for "
  end
  def test_get_key_bp
    key = :sale
    str = l10n_translator.gets(:items, key, :bp)
    assert str == "Esta aplicação está à venda para "
  end
  def test_get_key_fr
    key = :sale
    str = l10n_translator.gets(:items, key, :fr)
    assert str == "Cette application est en vente pour "
  end
  def test_get_key_es
    key = :sale
    str = l10n_translator.gets(:items, key, :es)
    assert str == "Esta aplicación está a la venta para "
  end
  def test_get_key_de
    key = :sale
    str = l10n_translator.gets(:items, key, :de)
    assert str == "Diese Anwendung ist für den Verkauf zu "
  end
  def test_get_key_it
    key = :sale
    str = l10n_translator.gets(:items, key, :it)
    assert str == "Questa applicazione è in vendita per "
  end
  
end