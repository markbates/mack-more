require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

class JPDateFormat < Mack::Localization::DateFormatEngine::Base
  def date_format_template(type)
    hash = ivar_cache("df_hash") do
      df_hash = {
        :df_short => "DD, yyyy年mm月dd日",
        :df_medium => "DD, yyyy年mm月dd日",
        :df_long => "DD, yyyy年mm月dd日"
      }
    end
    
    return hash["df_#{type}".to_sym]
  end

  def days_of_week(type)
    hash = ivar_cache("dow_hash") do
      dow_hash = {
        :dow_short => %w{月 火曜 水 木 金 土 太陽},
        :dow_medium => %w{月 火曜 水 木 金 土 太陽}, 
        :dow_long => %w{月曜日 火曜日 水曜日 木曜日 金曜日 土曜日 日曜日}
      }
    end
    return hash["dow_#{type}".to_sym]
  end

  def months(type)
    hash = ivar_cache("month_hash") do 
      month_hash = {
        :month_short => %w{1月 2月 3月 4月 5月 6月 7月 8月 9月 10月 11月 12月},
        :month_medium => %w{1月 2月 3月 4月 5月 6月 7月 8月 9月 10月 11月 12月},
        :month_long => %w{1月 2月 3月 4月 5月 6月 7月 8月 9月 10月 11月 12月}
      }
    end
    return hash["month_#{type}".to_sym]
  end
end

class JPNumberCurrencyFormat < Mack::Localization::NumberAndCurrencyFormatEngine::Base
  def delimiter
    return "."
  end
  
  def unit
    return "¥"
  end
  
  def separator
    return ","
  end
end

module FormatterTestHelper
    
  def ensure_reg_not_nil(reg_key)
    reg = Mack::Localization::FormatEngineRegistry.instance
    [:en, :bp, :fr, :it, :de, :es].each do |lang|
      reg.get_engine(lang, reg_key).should_not be_nil
    end
  end
  
  def register_japanese_support
    reg = Mack::Localization::FormatEngineRegistry.instance
    reg.register(:jp, l10n_formatter.date_format_registry_key, JPDateFormat.new)
    reg.register(:jp, l10n_formatter.currency_format_registry_key, JPNumberCurrencyFormat.new)
    return reg
  end
end

describe "Formatter Engine" do
  it "should not blow up" do 
    true
  end
  
  describe "=> Engine Registry" do
    
    include FormatterTestHelper
    
    it "should have access to registry instance anywhere" do
      Mack::Localization::FormatEngineRegistry.instance.should_not be_nil
    end
    
    it "should have date_format support for 5 languages out of box" do
      ensure_reg_not_nil(l10n_formatter.date_format_registry_key)
    end
    
    it "should have currency_format support for 5 languages out of box" do
      ensure_reg_not_nil(l10n_formatter.currency_format_registry_key)
    end
    
    it "should should not have the japanese support out of the box" do
      reg = Mack::Localization::FormatEngineRegistry.instance
      reg.get_engine(:jp, l10n_formatter.date_format_registry_key).should == nil
      reg.get_engine(:jp, l10n_formatter.currency_format_registry_key).should == nil
    end
    
    it "once registered, the engine should have japanese language supported" do
      reg = register_japanese_support
      reg.get_engine(:jp, l10n_formatter.date_format_registry_key).should_not be_nil
      reg.get_engine(:jp, l10n_formatter.currency_format_registry_key).should_not be_nil
    end
    
    it "once registered, the engine should be able to format date and currency for japanese language" do
      l10n_formatter.date_format(Time.now, :long, :jp).should_not be_empty
      l10n_formatter.date_format(Time.now, :medium, :jp).should_not be_empty
      l10n_formatter.date_format(Time.now, :short, :jp).should_not be_empty
      l10n_formatter.currency_format(1000.00, :jp).should_not be_empty
      l10n_formatter.number_format(1000.00, :jp).should_not be_empty
    end
  end
  
  describe "=> Exception handling" do
    include FormatterTestHelper
    
    it "should catch a valid exception if date_format is called with unknown language" do
      lambda { 
        l10n_formatter.date_format(Time.now, :long, :foo) 
      }.should raise_error(Mack::Localization::Errors::FormatEngineNotFound)
    end
    
    it "should catch a valid exception if date_format is called with unknown type" do
      lambda {
        l10n_formatter.date_format(Time.now, :bar, :en)
      }.should raise_error(Mack::Localization::Errors::InvalidArgument)
    end
    
    it "should catch a valid exception if currency_format is called with unknown language" do
      lambda {
        l10n_formatter.currency_format(1000.00, :foo)
      }.should raise_error(Mack::Localization::Errors::FormatEngineNotFound)
    end
    
    it "should catch a valid exception if number_format is called with unknown language" do
      lambda {
        l10n_formatter.number_format(1000.00, :foo)
      }.should raise_error(Mack::Localization::Errors::FormatEngineNotFound)
    end
  end
  
  describe "=> English Formatter" do
    it "should be able to format date using long_format" do
      time = Time.local(2008, "jan", 1)
      str = l10n_formatter.date_format(time, :long, :en)
      str.should == ("Tuesday, January 01, 2008")
    end
    it "should be able to format date using medium_format" do
      time = Time.local(2008, "jan", 1)
      str = l10n_formatter.date_format(time, :medium, :en)
      str.should == ("Tue, Jan 01, 2008")
    end
    it "should be able to format date using short_format" do
      time = Time.local(2008, "dec", 1)
      str = l10n_formatter.date_format(time, :short, :en)
      str.should == ("12/01/2008")
    end
    it "should be able to format number" do
      amt = 12000.50
      str = l10n_formatter.number_format(amt, :en)
      str.should == ("12,000.50")
    end
    it "should be able to format currency" do
      amt = 12000.50
      str = l10n_formatter.currency_format(amt, :en)
      str.should == ("$12,000.50")
    end
  end
  
  describe "=> French Formatter" do
    it "should be able to format date using long_format" do
      time = Time.local(2008, "jan", 1)
      str = l10n_formatter.date_format(time, :long, :fr)
      str.should == ("Mardi, 01 Janvier, 2008")
    end
    it "should be able to format date using medium_format" do
      time = Time.local(2008, "jan", 1)
      str = l10n_formatter.date_format(time, :medium, :fr)
      str.should == ("Mar, 01 Jan, 2008")
    end
    it "should be able to format date using short_format" do
      time = Time.local(2008, "dec", 1)
      str = l10n_formatter.date_format(time, :short, :fr)
      str.should == ("01/12/2008")
    end
    it "should be able to format number" do
      amt = 12000.50
      str = l10n_formatter.number_format(amt, :fr)
      str.should == ("12 000,50")
    end
    it "should be able to format currency" do
      amt = 12000.50
      str = l10n_formatter.currency_format(amt, :fr)
      str.should == ("€12 000,50")
    end
  end
  
  describe "=> Spanish Formatter" do
    it "should be able to format date using long_format" do
      time = Time.local(2008, "jan", 1)
      str = l10n_formatter.date_format(time, :long, :es)
      str.should == ("Martes, 01 Enero, 2008")
    end
    it "should be able to format date using medium_format" do
      time = Time.local(2008, "jan", 1)
      str = l10n_formatter.date_format(time, :medium, :es)
      str.should == ("Mar, 01 Ene, 2008")
    end
    it "should be able to format date using short_format" do
      time = Time.local(2008, "dec", 1)
      str = l10n_formatter.date_format(time, :short, :es)
      str.should == ("01/12/2008")
    end
    it "should be able to format number" do
      amt = 12000.50
      str = l10n_formatter.number_format(amt, :es)
      str.should == ("12.000,50")
    end
    it "should be able to format currency" do
      amt = 12000.50
      str = l10n_formatter.currency_format(amt, :es)
      str.should == ("€12.000,50")
    end
  end
  
  describe "=> German Formatter" do
    it "should be able to format date using long_format" do
      time = Time.local(2008, "jan", 1)
      str = l10n_formatter.date_format(time, :long, :de)
      str.should == ("Dienstag, 01 Januar, 2008")
    end
    it "should be able to format date using medium_format" do
      time = Time.local(2008, "jan", 1)
      str = l10n_formatter.date_format(time, :medium, :de)
      str.should == ("Die, 01 Jan, 2008")
    end
    it "should be able to format date using short_format" do
      time = Time.local(2008, "dec", 1)
      str = l10n_formatter.date_format(time, :short, :de)
      str.should == ("01/12/2008")
    end
    it "should be able to format number" do
      amt = 12000.50
      str = l10n_formatter.number_format(amt, :de)
      str.should == ("12.000,50")
    end
    it "should be able to format currency" do
      amt = 12000.50
      str = l10n_formatter.currency_format(amt, :de)
      str.should == ("€12.000,50")
    end
  end
  
  describe "=> Brazilian Portuguese Formatter" do
    it "should be able to format date using long_format" do
      time = Time.local(2008, "jan", 1)
      str = l10n_formatter.date_format(time, :long, :bp)
      str.should == ("Terça, 01 Janeiro, 2008")
    end
    it "should be able to format date using medium_format" do
      time = Time.local(2008, "jan", 1)
      str = l10n_formatter.date_format(time, :medium, :bp)
      str.should == ("Ter, 01 Jan, 2008")
    end
    it "should be able to format date using short_format" do
      time = Time.local(2008, "dec", 1)
      str = l10n_formatter.date_format(time, :short, :bp)
      str.should == ("01/12/2008")
    end
    it "should be able to format number" do
      amt = 12000.50
      str = l10n_formatter.number_format(amt, :bp)
      str.should == ("12,000.50")
    end
    it "should be able to format currency" do
      amt = 12000.50
      str = l10n_formatter.currency_format(amt, :bp)
      str.should == ("R$12,000.50")
    end
  end
  
  describe "=> Italian Formatter" do
    it "should be able to format date using long_format" do
      time = Time.local(2008, "jan", 1)
      str = l10n_formatter.date_format(time, :long, :it)
      str.should == ("Martedì, 01 Gennaio, 2008")
    end
    it "should be able to format date using medium_format" do
      time = Time.local(2008, "jan", 1)
      str = l10n_formatter.date_format(time, :medium, :it)
      str.should == ("Mar, 01 Gen, 2008")
    end
    it "should be able to format date using short_format" do
      time = Time.local(2008, "dec", 1)
      str = l10n_formatter.date_format(time, :short, :it)
      str.should == ("01/12/2008")
    end
    it "should be able to format number" do
      amt = 12000.50
      str = l10n_formatter.number_format(amt, :it)
      str.should == ("12.000,50")
    end
    it "should be able to format currency" do
      amt = 12000.50
      str = l10n_formatter.currency_format(amt, :it)
      str.should == ("€12.000,50")
    end
  end
end
