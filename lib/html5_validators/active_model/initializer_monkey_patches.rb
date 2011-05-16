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
    end

    class NumericalityValidator
      def initialize(options)
        super
      end
    end
  end
end
