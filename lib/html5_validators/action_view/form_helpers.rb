# frozen_string_literal: true
module Html5Validators
  module ActionViewExtension
    module FormHelper
      def form_for(record, options = {}, &block)
        if record.respond_to?(:auto_html5_validation=)
          if !Html5Validators.enabled || (options[:auto_html5_validation] == false)
            record.auto_html5_validation = false
          end
        end
        super
      end
    end

    module PresenceValidator
      def render
        if object.class.ancestors.include?(ActiveModel::Validations) && (object.auto_html5_validation != false) && (object.class.auto_html5_validation != false)
          @options["required"] = @options[:required] if @options["required"].nil?
          @options["required"] = object.class.attribute_required?(@method_name) if @options["required"].nil?
        end
        super
      end
    end

    module LengthValidator
      def render
        if object.class.ancestors.include?(ActiveModel::Validations) && (object.auto_html5_validation != false) && (object.class.auto_html5_validation != false)
          @options["maxlength"] ||= @options[:maxlength] || object.class.attribute_maxlength(@method_name)
          @options["minlength"] ||= @options[:minlength] || object.class.attribute_minlength(@method_name)
        end
        super
      end
    end

    module NumericalityValidator
      def render
        if object.class.ancestors.include?(ActiveModel::Validations) && (object.auto_html5_validation != false) && (object.class.auto_html5_validation != false)
          @options["max"] ||= @options["max"] || @options[:max] || object.class.attribute_max(@method_name)
          @options["min"] ||= @options["min"] || @options[:min] || object.class.attribute_min(@method_name)
        end
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
