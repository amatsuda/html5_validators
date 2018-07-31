# frozen_string_literal: true

# Legacy Rails 3.x support
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

    class InstanceTag
      def to_input_field_tag_with_html5_attributes(field_type, options = {})
        if object.class.ancestors.include?(ActiveModel::Validations) && (object.auto_html5_validation != false) && (object.class.auto_html5_validation != false)
          options["required"] ||= object.class.attribute_required?(method_name)
          options["maxlength"] ||= object.class.attribute_maxlength(method_name)
          options["minlength"] ||= object.class.attribute_minlength(method_name)
          options["max"] ||= object.class.attribute_max(method_name)
          options["min"] ||= object.class.attribute_min(method_name)
        end
        to_input_field_tag_without_html5_attributes field_type, options
      end
      alias_method_chain :to_input_field_tag, :html5_attributes

      def to_text_area_tag_with_html5_attributes(options = {})
        if object.class.ancestors.include?(ActiveModel::Validations) && (object.auto_html5_validation != false) && (object.class.auto_html5_validation != false)
          options["required"] ||= object.class.attribute_required?(method_name)
          options["maxlength"] ||= object.class.attribute_maxlength(method_name)
          options["minlength"] ||= object.class.attribute_minlength(method_name)
        end
        to_text_area_tag_without_html5_attributes options
      end
      alias_method_chain :to_text_area_tag, :html5_attributes

      def to_radio_button_tag_with_html5_attributes(tag_value, options = {})
        if object.class.ancestors.include?(ActiveModel::Validations) && (object.auto_html5_validation != false) && (object.class.auto_html5_validation != false)
          options["required"] ||= object.class.attribute_required?(method_name)
        end
        to_radio_button_tag_without_html5_attributes tag_value, options
      end
      alias_method_chain :to_radio_button_tag, :html5_attributes

      def to_check_box_tag_with_html5_attributes(options = {}, checked_value = "1", unchecked_value = "0")
        if object.class.ancestors.include?(ActiveModel::Validations) && (object.auto_html5_validation != false) && (object.class.auto_html5_validation != false)
          options["required"] ||= object.class.attribute_required?(method_name)
        end
        to_check_box_tag_without_html5_attributes options, checked_value, unchecked_value
      end
      alias_method_chain :to_check_box_tag, :html5_attributes
    end
  end
end
