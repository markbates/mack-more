require File.dirname(__FILE__) + '/../test_helper.rb'

class FormatterTest < Test::Unit::TestCase

  def test_long_date_format_en
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :long, :en)
    assert str==("Tuesday, January 01, 2008")
  end
  
  def test_long_date_format_fr
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :long, :fr)
    assert str==("Mardi, 01 Janvier, 2008")
  end
  
  def test_long_date_format_es
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :long, :es)
    assert str==("Martes, 01 Enero, 2008")
  end
  
  def test_long_date_format_bp
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :long, :bp)
    assert str==("Terça, 01 Janeiro, 2008")
  end
  
  def test_long_date_format_it
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :long, :it)
    assert str==("Martedì, 01 Gennaio, 2008")
  end
  
  def test_long_date_format_de
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :long, :de)
    assert str==("Dienstag, 01 Januar, 2008")
  end
  
  def test_medium_date_format_en
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :medium, :en)
    assert str==("Tue, Jan 01, 2008")
  end
  
  def test_medium_date_format_bp
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :medium, :bp)
    assert str==("Ter, 01 Jan, 2008")
  end
  
  def test_medium_date_format_fr
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :medium, :fr)
    assert str==("Mar, 01 Jan, 2008")
  end
  
  def test_medium_date_format_it
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :medium, :it)
    assert str==("Mar, 01 Gen, 2008")
  end
  
  def test_medium_date_format_de
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :medium, :de)
    assert str==("Die, 01 Jan, 2008")
  end
  
  def test_medium_date_format_es
    time = Time.local(2008, "jan", 1)
    str = l10n_formatter.date_format(time, :medium, :es)
    assert str==("Mar, 01 Ene, 2008")
  end
  
  def test_short_date_format_en
    time = Time.local(2008, "dec", 1)
    str = l10n_formatter.date_format(time, :short, :en)
    assert str==("12/01/2008")
  end
  
  def test_short_date_format_bp
    time = Time.local(2008, "dec", 1)
    str = l10n_formatter.date_format(time, :short, :bp)
    assert str==("01/12/2008")
  end
  
  def test_short_date_format_es
    time = Time.local(2008, "dec", 1)
    str = l10n_formatter.date_format(time, :short, :es)
    assert str==("01/12/2008")
  end
  
  def test_short_date_format_fr
    time = Time.local(2008, "dec", 1)
    str = l10n_formatter.date_format(time, :short, :fr)
    assert str==("01/12/2008")
  end
  
  def test_short_date_format_de
    time = Time.local(2008, "dec", 1)
    str = l10n_formatter.date_format(time, :short, :de)
    assert str==("01/12/2008")
  end
  
  def test_short_date_format_it
    time = Time.local(2008, "dec", 1)
    str = l10n_formatter.date_format(time, :short, :it)
    assert str==("01/12/2008")
  end
  
  def test_number_format_en
    amt = 12000.50
    str = l10n_formatter.number_format(amt, :en)
    assert str==("12,000.50")
  end
  
  def test_number_format_fr
    amt = 12000.50
    str = l10n_formatter.number_format(amt, :fr)
    assert str==("12 000,50")
  end
  
  def test_number_format_de
    amt = 12000.50
    str = l10n_formatter.number_format(amt, :de)
    assert str==("12.000,50")
  end
  
  def test_number_format_it
    amt = 12000.50
    str = l10n_formatter.number_format(amt, :it)
    assert str==("12.000,50")
  end
  
  def test_number_format_es
    amt = 12000.50
    str = l10n_formatter.number_format(amt, :es)
    assert str==("12.000,50")
  end
  
  def test_number_format_bp
    amt = 12000.50
    str = l10n_formatter.number_format(amt, :bp)
    assert str==("12,000.50")
  end

  def test_currency_format_en
    amt = 12000.50
    str = l10n_formatter.currency_format(amt, :en)
    assert str==("$12,000.50")
  end
  
  def test_currency_format_fr
    amt = 12000.50
    str = l10n_formatter.currency_format(amt, :fr)
    assert str==("€12 000,50")
  end
  
  def test_currency_format_de
    amt = 12000.50
    str = l10n_formatter.currency_format(amt, :de)
    assert str==("€12.000,50")
  end
  
  def test_currency_format_it
    amt = 12000.50
    str = l10n_formatter.currency_format(amt, :it)
    assert str==("€12.000,50")
  end
  
  def test_currency_format_es
    amt = 12000.50
    str = l10n_formatter.currency_format(amt, :es)
    assert str==("€12.000,50")
  end
  
  def test_currency_format_bp
    amt = 12000.50
    str = l10n_formatter.currency_format(amt, :bp)
    assert str==("R$12,000.50")
  end
  
end