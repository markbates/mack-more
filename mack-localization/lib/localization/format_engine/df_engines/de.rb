module Mack
  module Localization
    module DateFormatEngine
      class DE < Base
        
        def date_format_template(type)
          hash = ivar_cache("df_hash") do
            df_hash = {
              :df_short    => "dd/mm/yyyy",
              :df_medium   => "DD, dd MM, yyyy",
              :df_long     => "DD, dd MM, yyyy"
            }
          end
          return hash["df_#{type}".to_sym]
        end
        
        def days_of_week(type)
          hash = ivar_cache("dow_hash") do 
            dow_hash = {
              :dow_short   => %w{M D M D F S S},
              :dow_medium   => %w{Mon Die Mit Don Fre Sam Son},
              :dow_long    => %w{Montag Dienstag Mittwoch Donnerstag Freitag Samstag Sonntag},
            }
          end
          return hash["dow_#{type}".to_sym]
        end
        
        def months(type)
          hash = ivar_cache("m_hash") do 
            m_hash = {
              :month_short => %w{Jan Feb Mär Apr Mai Jun Jul Aug Sep Okt Nov Dez},
              :month_medium => %w{Jan Feb Mär Apr Mai Jun Jul Aug Sep Okt Nov Dez},
              :month_long  => %w{Januar Februar März April Mai Juni Juli August September Oktober November Dezember}
            }
          end
          return hash["month_#{type}".to_sym]
        end
        
      end
    end
  end
end
