module ActionView
  module Helpers
    class InstanceTag
      def to_input_field_tag_with_html5_attributes(field_type, options = {})
        if object.class.ancestors.include?(ActiveModel::Validations)
          options["required"] ||= object.class.attribute_required?(method_name)
          options["maxlength"] ||= object.class.attribute_maxlength(method_name)
          options["max"] ||= object.class.attribute_max(method_name)
          options["min"] ||= object.class.attribute_min(method_name)
        end
        to_input_field_tag_without_html5_attributes field_type, options
      end

      alias_method_chain :to_input_field_tag, :html5_attributes
    end
  end
end
