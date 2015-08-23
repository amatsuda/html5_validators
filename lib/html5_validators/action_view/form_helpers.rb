module Html5Validators
  module ActionViewExtension
    module FormHelper
      def form_for(record, options = {}, &block)
        if record.respond_to?(:auto_html5_validation=)
          if options.key?(:auto_html5_validation)
            record.auto_html5_validation = options[:auto_html5_validation]
          end
        end
        super
      end
    end

    module PresenceValidator
      def render
        @options["required"] ||= @options[:required] || object.class.attribute_required?(@method_name) if Html5Validators.validation_enabled?(:required, object)
        super
      end
    end

    module LengthValidator
      def render
        @options["maxlength"] ||= @options[:maxlength] || object.class.attribute_maxlength(@method_name) if Html5Validators.validation_enabled?(:maxlength, object)
        @options["minlength"] ||= @options[:minlength] || object.class.attribute_minlength(@method_name) if Html5Validators.validation_enabled?(:minlength, object)
        super
      end
    end

    module NumericalityValidator
      def render
        @options["max"] ||= @options["max"] || @options[:max] || object.class.attribute_max(@method_name) if Html5Validators.validation_enabled?(:max, object)
        @options["min"] ||= @options["min"] || @options[:min] || object.class.attribute_min(@method_name) if Html5Validators.validation_enabled?(:min, object)
        super
      end
    end
  end
end


module ActionView
  Base.send :prepend, Html5Validators::ActionViewExtension::FormHelper

  module Helpers
    module Tags
      class TextField
        prepend Html5Validators::ActionViewExtension::NumericalityValidator
        prepend Html5Validators::ActionViewExtension::LengthValidator
        prepend Html5Validators::ActionViewExtension::PresenceValidator
      end

      class TextArea
        prepend Html5Validators::ActionViewExtension::LengthValidator
        prepend Html5Validators::ActionViewExtension::PresenceValidator
      end

      #TODO probably I have to add some more classes here
      [RadioButton, CheckBox, Select, DateSelect, TimeZoneSelect].each do |kls|
        kls.send :prepend, Html5Validators::ActionViewExtension::PresenceValidator
      end
    end
  end
end
