module Mack
  module Localization # :nodoc:
    module DateFormatEngine # :nodoc:
      class EN < Base
        
        def date_format_template(type)
          hash = ivar_cache("df_hash") do
            df_hash = {
              :df_short    => "mm/dd/yyyy",
              :df_medium   => "DD, MM dd, yyyy",
              :df_long     => "DD, MM dd, yyyy"
            }
          end
          
          return hash["df_#{type}".to_sym]
        end
        
        def days_of_week(type)
          hash = ivar_cache("dow_hash") do 
            dow_hash = {
              :dow_short => %w{M T W T F S S},
              :dow_medium => %w{Mon Tue wed Thu Fri Sat Sun},
              :dow_long => %w{Monday Tuesday Wednesday Thursday Friday Saturday Sunday}
            }
          end
          return hash["dow_#{type}".to_sym]
        end
        
        def months(type)
          hash = ivar_cache("m_hash") do 
            m_hash = {
              :month_short => %w{Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec},
              :month_medium => %w{Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec},
              :month_long  => %w{January February March April May June July August September October November December}
            }
          end
          return hash["month_#{type}".to_sym]
        end
        
      end
    end
  end
end
