# Legacy Ruby 1.x on Rails 4.x support
module Html5Validators
  module ActionViewExtension
    def inject_required_attribute
      @options["required"] ||= @options[:required] || object.class.attribute_required?(@method_name) if Html5Validators.validation_enabled?(:required, object)
    end

    def inject_maxlength_attribute
      @options["maxlength"] ||= @options[:maxlength] || object.class.attribute_maxlength(@method_name) if Html5Validators.validation_enabled?(:maxlength, object)
      @options["minlength"] ||= @options[:minlength] || object.class.attribute_minlength(@method_name) if Html5Validators.validation_enabled?(:minlength, object)
    end

    def inject_numericality_attributes
      @options["max"] ||= @options["max"] || @options[:max] || object.class.attribute_max(@method_name) if Html5Validators.validation_enabled?(:max, object)
      @options["min"] ||= @options["min"] || @options[:min] || object.class.attribute_min(@method_name) if Html5Validators.validation_enabled?(:min, object)
    end
  end
end


module ActionView
  module Helpers
    module FormHelper
      def form_for_with_auto_html5_validation_option(record, options = {}, &proc)
        if record.respond_to?(:auto_html5_validation=)
          if options.key?(:auto_html5_validation)
            record.auto_html5_validation = options[:auto_html5_validation]
          end
        end
        form_for_without_auto_html5_validation_option record, options, &proc
      end
      alias_method_chain :form_for, :auto_html5_validation_option
    end

    module Tags
      class Base #:nodoc:
        include Html5Validators::ActionViewExtension
      end

      class TextField
        def render_with_html5_attributes
          inject_required_attribute
          inject_maxlength_attribute
          inject_numericality_attributes

          render_without_html5_attributes
        end
        alias_method_chain :render, :html5_attributes
      end

      class TextArea
        def render_with_html5_attributes
          inject_required_attribute
          inject_maxlength_attribute

          render_without_html5_attributes
        end
        alias_method_chain :render, :html5_attributes
      end

      #TODO probably I have to add some more classes here
      [RadioButton, CheckBox, Select, DateSelect, TimeZoneSelect].each do |kls|
        kls.class_eval do
          def render_with_html5_attributes
            inject_required_attribute
            render_without_html5_attributes
          end
          alias_method_chain :render, :html5_attributes
        end
      end
    end
  end
end
