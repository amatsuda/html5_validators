module Html5Validators
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    # Future subclasses will pick up the model extension
    module ClassMethods

      def inherited(kls)
        super
        kls.class_eval do
          cattr_accessor :auto_html5_validation, :instance_accessor => false, :instance_reader => false, :instance_writer => false
        end if kls.superclass == ActiveRecord::Base
      end
    end

    included do
      # Existing subclasses pick up the model extension as well
      self.descendants.each do |kls|
        cattr_accessor :auto_html5_validation, :instance_accessor => false, :instance_reader => false, :instance_writer => false if kls.superclass == ActiveRecord::Base
      end
    end
  end
end

ActiveRecord::Base.send(:include, Html5Validators::ActiveRecordExtension)
