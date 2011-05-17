# A freedom patch for AMo 3.0.x and 3.1.0.beta1
# see: https://github.com/rails/rails/pull/1085
module ActiveModel
  module Validations
    class LengthValidator
      def initialize(options)
        if range = (options.delete(:in) || options.delete(:within))
          raise ArgumentError, ":in and :within must be a Range" unless range.is_a?(Range)
          options[:minimum], options[:maximum] = range.begin, range.end
          options[:maximum] -= 1 if range.exclude_end?
        end

        super
      end

      def validate_each_with_default_tokenizer(record, attribute, value)
        @options = (options || {}).reverse_merge(:tokenizer => DEFAULT_TOKENIZER).freeze
        validate_each_without_default_tokenizer record, attribute, value
      end
      alias_method_chain :validate_each, :default_tokenizer
    end

    class NumericalityValidator
      def initialize(options)
        super
      end
    end
  end
end
