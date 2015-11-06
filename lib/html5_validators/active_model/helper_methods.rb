module ActiveModel
  module Validations
    module HelperMethods
      def attribute_required?(attribute)
        self.validators.grep(PresenceValidator).any? do |v|
          v.attributes.include?(attribute.to_sym) && (v.options.keys & [:if, :unless]).empty?
        end
      end

      def attribute_maxlength(attribute)
        self.validators.grep(LengthValidator).select {|v|
          v.attributes.include?(attribute.to_sym) && (v.options.keys & [:maximum, :is]).any? && (v.options.keys & [:if, :unless, :tokenizer]).empty?
        }.map {|v| v.options.slice(:maximum, :is)}.map(&:values).flatten.max
      end

      def attribute_minlength(attribute)
        self.validators.grep(LengthValidator).select {|v|
          v.attributes.include?(attribute.to_sym) && (v.options.keys & [:minimum, :is]).any? && (v.options.keys & [:if, :unless, :allow_nil, :allow_blank, :tokenizer]).empty?
        }.map {|v| v.options.slice(:minimum, :is)}.map(&:values).flatten.min
      end

      def attribute_max(attribute)
        self.validators.grep(NumericalityValidator).select {|v|
          v.attributes.include?(attribute.to_sym) && (v.options.keys & [:less_than, :less_than_or_equal_to]).any? && (v.options.keys & [:if, :unless, :allow_nil, :allow_blank]).empty?
        }.map {|v| v.options.slice(:less_than, :less_than_or_equal_to)}.map(&:values).flatten.max
      end

      def attribute_min(attribute)
        self.validators.grep(NumericalityValidator).select {|v|
          v.attributes.include?(attribute.to_sym) && (v.options.keys & [:greater_than, :greater_than_or_equal_to]).any? && (v.options.keys & [:if, :unless, :allow_nil, :allow_blank]).empty?
        }.map {|v| v.options.slice(:greater_than, :greater_than_or_equal_to)}.map(&:values).flatten.min
      end
    end
  end
end
