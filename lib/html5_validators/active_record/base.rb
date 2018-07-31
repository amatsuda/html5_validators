# frozen_string_literal: true

module Html5Validators
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    # Future subclasses will pick up the model extension
    module ClassMethods
      def inherited(kls)
        super
        class << kls
          attr_accessor :auto_html5_validation
        end
        kls.auto_html5_validation = true
      end
    end

    included do
      # Existing subclasses pick up the model extension as well
      self.descendants.each do |kls|
        class << kls
          attr_accessor :auto_html5_validation
        end
        kls.auto_html5_validation = true
      end
    end
  end
end

ActiveRecord::Base.send(:include, Html5Validators::ActiveRecordExtension)
