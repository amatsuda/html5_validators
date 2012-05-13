module Html5Validators
  module ActionViewExtension
    def inject_required_field
      if object.class.ancestors.include?(ActiveModel::Validations) && (object.auto_html5_validation != false)
        @options["required"] ||= object.class.attribute_required?(@method_name)
      end
    end
  end
end if ActionPack::VERSION::STRING >= '4'


module ActionView
  module Helpers
    module FormHelper
      def form_for_with_auto_html5_validation_option(record, options = {}, &proc)
        record.auto_html5_validation = false if (options[:auto_html5_validation] == false) && (record.respond_to? :auto_html5_validation=)
        form_for_without_auto_html5_validation_option record, options, &proc
      end
      alias_method_chain :form_for, :auto_html5_validation_option
    end

    if ActionPack::VERSION::STRING >= '4'
      module Tags
        class Base #:nodoc:
          include Html5Validators::ActionViewExtension
        end

        class TextField
          def render_with_html5_attributes
            inject_required_field

            if object.class.ancestors.include?(ActiveModel::Validations) && (object.auto_html5_validation != false)
              @options["maxlength"] ||= object.class.attribute_maxlength(@method_name)
              @options["max"] ||= object.class.attribute_max(@method_name)
              @options["min"] ||= object.class.attribute_min(@method_name)
            end
            render_without_html5_attributes
          end
          alias_method_chain :render, :html5_attributes
        end

        #TODO probably I have to add some more classes here
        [TextArea, RadioButton, CheckBox, Select, DateSelect, TimeZoneSelect].each do |kls|
          kls.class_eval do
            def render_with_html5_attributes
              inject_required_field
              render_without_html5_attributes options
            end
            alias_method_chain :render, :html5_attributes
          end
        end
      end
    # ActionPack::VERSION::STRING == '3'
    else
      class InstanceTag
        def to_input_field_tag_with_html5_attributes(field_type, options = {})
          if object.class.ancestors.include?(ActiveModel::Validations) && (object.auto_html5_validation != false)
            options["required"] ||= object.class.attribute_required?(method_name)
            options["maxlength"] ||= object.class.attribute_maxlength(method_name)
            options["max"] ||= object.class.attribute_max(method_name)
            options["min"] ||= object.class.attribute_min(method_name)
          end
          to_input_field_tag_without_html5_attributes field_type, options
        end
        alias_method_chain :to_input_field_tag, :html5_attributes

        def to_text_area_tag_with_html5_attributes(options = {})
          if object.class.ancestors.include?(ActiveModel::Validations) && (object.auto_html5_validation != false)
            options["required"] ||= object.class.attribute_required?(method_name)
          end
          to_text_area_tag_without_html5_attributes options
        end
        alias_method_chain :to_text_area_tag, :html5_attributes

        def to_radio_button_tag_with_html5_attributes(tag_value, options = {})
          if object.class.ancestors.include?(ActiveModel::Validations) && (object.auto_html5_validation != false)
            options["required"] ||= object.class.attribute_required?(method_name)
          end
          to_radio_button_tag_without_html5_attributes tag_value, options
        end
        alias_method_chain :to_radio_button_tag, :html5_attributes

        def to_check_box_tag_with_html5_attributes(options = {}, checked_value = "1", unchecked_value = "0")
          if object.class.ancestors.include?(ActiveModel::Validations) && (object.auto_html5_validation != false)
            options["required"] ||= object.class.attribute_required?(method_name)
          end
          to_check_box_tag_without_html5_attributes options, checked_value, unchecked_value
        end
        alias_method_chain :to_check_box_tag, :html5_attributes
      end
    end
  end
end
