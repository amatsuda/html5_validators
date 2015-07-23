module Html5Validators
  module ActionViewExtension
    def inject_required_field
      if object.class.ancestors.include?(ActiveModel::Validations) && (object.auto_html5_validation != false) && (object.class.auto_html5_validation != false)
        @options["required"] ||= @options[:required] || object.class.attribute_required?(@method_name)
      end
    end

    def inject_maxlength_field
      if object.class.ancestors.include?(ActiveModel::Validations) && (object.auto_html5_validation != false) && (object.class.auto_html5_validation != false)
        @options["maxlength"] ||= @options[:maxlength] || object.class.attribute_maxlength(@method_name)
      end
    end
  end
end


module ActionView
  module Helpers
    module FormHelper
      def form_for_with_auto_html5_validation_option(record, options = {}, &proc)
        if record.respond_to?(:auto_html5_validation=)
          if !Html5Validators.enabled || (options[:auto_html5_validation] == false)
            record.auto_html5_validation = false
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
            inject_required_field
            inject_maxlength_field

            if object.class.ancestors.include?(ActiveModel::Validations) && (object.auto_html5_validation != false) && (object.class.auto_html5_validation != false)
              @options["max"] ||= @options["max"] || @options[:max] || object.class.attribute_max(@method_name)
              @options["min"] ||= @options["min"] || @options[:min] || object.class.attribute_min(@method_name)
            end
            render_without_html5_attributes
          end
          alias_method_chain :render, :html5_attributes
        end

        class TextArea
          def render_with_html5_attributes
            inject_required_field
            inject_maxlength_field

            render_without_html5_attributes
          end
          alias_method_chain :render, :html5_attributes
        end

        #TODO probably I have to add some more classes here
        [RadioButton, CheckBox, Select, DateSelect, TimeZoneSelect].each do |kls|
          kls.class_eval do
            def render_with_html5_attributes
              inject_required_field
              render_without_html5_attributes
            end
            alias_method_chain :render, :html5_attributes
          end
        end
      end
  end
end
