module Mack
  module Localization
    module DateFormatEngine
      class IT < Base
        
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
              :dow_short   => %w{L M M G V S D},
              :dow_medium  => %w{Lun Mar Mer Gio Ven Sab Dom},
              :dow_long    => %w{Lunedi Martedì Mercoledì Giovedi Venerdì Sabato Domenica}
            }
          end
          return hash["dow_#{type}".to_sym]
        end
        
        def months(type)
          hash = ivar_cache("m_hash") do 
            m_hash = {
              :month_short => %w{Gen Feb Mar Apr Mag Giu Lug Ago Set Ott Nov Dic},
              :month_medium => %w{Gen Feb Mar Apr Mag Giu Lug Ago Set Ott Nov Dic},
              :month_long  => %w{Gennaio Febbraio Marzo Aprile Maggio Giugno Luglio Agosto Settembre Ottobre Novembre Dicembre}
            }
          end
          return hash["month_#{type}".to_sym]
        end
        
      end
    end
  end
end
