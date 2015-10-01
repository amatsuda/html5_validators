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
          v.attributes.include?(attribute.to_sym) && (v.options.keys & [:maximum, :is]).any? && (v.options.keys & [:if, :unless, :allow_nil, :allow_blank, :tokenizer]).empty?
        }.map {|v| v.options.slice(:maximum, :is)}.map(&:values).flatten.max
      end

      def attribute_minlength(attribute)
        self.validators.grep(LengthValidator).select {|v|
          v.attributes.include?(attribute.to_sym) && (v.options.keys & [:minimum, :is]).any? && (v.options.keys & [:if, :unless, :allow_nil, :allow_blank, :tokenizer]).empty?
        }.map {|v| v.options.slice(:minimum, :is)}.map(&:values).flatten.min
      end

      def attribute_max(attribute)
        less_than_max = self.validators.grep(NumericalityValidator).select {|v|
          v.attributes.include?(attribute.to_sym) && (v.options.keys & [:less_than]).any? && (v.options.keys & [:if, :unless, :allow_nil, :allow_blank]).empty?
        }.map {|v| v.options.slice(:less_than)}.map(&:values).flatten.max
        less_than_max = less_than_max - 1 if less_than_max # Ensure we're not allowing the value to be equal to the max specified

        less_than_or_equal_to_max = self.validators.grep(NumericalityValidator).select {|v|
          v.attributes.include?(attribute.to_sym) && (v.options.keys & [:less_than_or_equal_to]).any? && (v.options.keys & [:if, :unless, :allow_nil, :allow_blank]).empty?
        }.map {|v| v.options.slice(:less_than_or_equal_to)}.map(&:values).flatten.max

        [less_than_max, less_than_or_equal_to_max].compact.max
      end

      def attribute_min(attribute)
        greater_than_min = self.validators.grep(NumericalityValidator).select {|v|
          v.attributes.include?(attribute.to_sym) && (v.options.keys & [:greater_than]).any? && (v.options.keys & [:if, :unless, :allow_nil, :allow_blank]).empty?
        }.map {|v| v.options.slice(:greater_than)}.map(&:values).flatten.min
        greater_than_min = greater_than_min + 1 if greater_than_min # Ensure we're not allowing the value to be equal to the min specified

        greater_than_or_equal_to_min = self.validators.grep(NumericalityValidator).select {|v|
          v.attributes.include?(attribute.to_sym) && (v.options.keys & [:greater_than_or_equal_to]).any? && (v.options.keys & [:if, :unless, :allow_nil, :allow_blank]).empty?
        }.map {|v| v.options.slice(:greater_than_or_equal_to)}.map(&:values).flatten.min

        [greater_than_min, greater_than_or_equal_to_min].compact.min
      end
    end
  end
end
