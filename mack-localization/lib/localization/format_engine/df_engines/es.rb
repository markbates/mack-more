module Mack
  module Localization # :nodoc:
    module DateFormatEngine # :nodoc:
      class ES < Base
        
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
              :dow_medium  => %w{Lun Mar Mié Jue Vie Sáb Dom},
              :dow_long    => %w{Lunes Martes Mi\303\251rcoles Jueves Viernes S\303\241bado Domingo}
            }
          end
          return hash["dow_#{type}".to_sym]
        end
        
        def months(type)
          hash = ivar_cache("m_hash") do 
            m_hash = {
              :month_short => %w{Ene Feb Mar Abr May Jun Jul Ago Sep Oct Nov Dic},
              :month_medium => %w{Ene Feb Mar Abr May Jun Jul Ago Sep Oct Nov Dic},
              :month_long  => %w{Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre}
            }
          end
          return hash["month_#{type}".to_sym]
        end
        
      end
    end
  end
end
