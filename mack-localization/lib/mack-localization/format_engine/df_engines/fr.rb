module Mack
  module Localization # :nodoc:
    module DateFormatEngine # :nodoc:
      class FR < Base
        
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
              :dow_short   => %w{L M M J V S D},
              :dow_medium   => %w{Lun Mar Mer Jeu Ven Sam Dim},
              :dow_long    => %w{Lundi Mardi Mercredi Jeudi vendredi samedi dimanche},
            }
          end
          return hash["dow_#{type}".to_sym]
        end
        
        def months(type)
          hash = ivar_cache("m_hash") do 
            m_hash = {
              :month_short => %w{Jan Fév Mar Avr Mai Jun Jui Aoû Sep Oct Nov Dec},
              :month_medium => %w{Jan Fév Mar Avr Mai Jun Jui Aoû Sep Oct Nov Dec},
              :month_long  => %w{Janvier Février Mars Avril Mai Juin Juillet Août Septembre Octobre Novembre Décembre},
            }
          end
          return hash["month_#{type}".to_sym]
        end
        
      end
    end
  end
end
