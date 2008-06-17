module Mack
  module Localization
    module DateFormatEngine
      class BP < Base
        
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
              :dow_short   => %w{S T Q Q S S D},
              :dow_medium  => %w{Seg Ter Qua Qui Sex Sáb Dom},
              :dow_long    => %w{Segunda Terça Quarta Quinta Sexta Sábado Domingo}
            }
          end
          return hash["dow_#{type}".to_sym]
        end
        
        def months(type)
          hash = ivar_cache("m_hash") do 
            m_hash = {
              :month_short => %w{Jan Fev Mar Abr Mai Jun Jul Ago Set Out Nov Dez},
              :month_medium => %w{Jan Fev Mar Abr Mai Jun Jul Ago Set Out Nov Dez},
              :month_long  => %w{Janeiro Fevereiro Março Abril Maio Junho Julho Agosto Setembro Outubro Novembro Dezembro}
            }
          end
          return hash["month_#{type}".to_sym]
        end
        
      end
    end
  end
end
