unless defined?(Sass::MACK_LOADED)
  Sass::MACK_LOADED = true

  Sass::Plugin.options.merge!(:template_location  => Mack::Paths.app('sass'),
                              :css_location       => Mack::Paths.stylesheets,
                              :always_check       => !Mack.env?(:production),
                              :full_exception     => !Mack.env?(:production))

  # :stopdoc:
  module Mack
    module Controller
      alias_method :sass_old_run, :run
      def run
        if !Sass::Plugin.checked_for_updates ||
            Sass::Plugin.options[:always_update] || Sass::Plugin.options[:always_check]
          Sass::Plugin.update_stylesheets
        end

        sass_old_run
      end
    end
  end
  # :startdoc:
end