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

begin
  puts "registering Japanese date format and currency format"
  registry = Mack::Localization::FormatEngineRegistry.instance
  
  registry.register(:jp, :date_format, JPDateFormat.new)
  registry.register(:jp, :currency_format, JPNumberCurrencyFormat.new)
  
  pp registry
end