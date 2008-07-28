module Mack
  module Data
    module Factory
      
      class FieldContentGenerator
        class << self
          def alpha_generator
            @alpha_gen ||= Proc.new do |def_value, rules|
              "#{def_value}abcdef"
            end
            return @alpha_gen
          end

          def alpha_numeric_generator
            @alpha_numeric_gen ||= Proc.new do |def_value, rules|
              "#{def_value}123abcdef"
            end
            return @alpha_numeric_gen
          end

          def numeric_generator
            @numeric_gen ||= Proc.new do |def_value, rules|
              "#{def_value}123456"
            end
            return @numeric_gen
          end

          def date_generator
            @date_gen ||= Proc.new do |def_value, rules|
              Time.now.to_s
            end
            return @date_gen
          end

          def date_time_generator
            @date_time_gen ||= Proc.new do |def_value, rules|
              Time.now.to_s
            end
            return @date_time_gen
          end
        end
      end

    end
  end
end