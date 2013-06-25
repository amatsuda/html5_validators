module ActiveRecord
  class Base
    # Future subclasses will pick up the model extension
    class << self
      def inherited_with_html5_validation(kls) #:nodoc:
        inherited_without_html5_validation kls
        kls.class_eval do
          cattr_accessor :auto_html5_validation, :instance_accessor => false, :instance_reader => false, :instance_writer => false
        end if kls.superclass == ActiveRecord::Base
      end
      alias_method_chain :inherited, :html5_validation
    end

    # Existing subclasses pick up the model extension as well
    self.descendants.each do |kls|
      cattr_accessor :auto_html5_validation, :instance_accessor => false, :instance_reader => false, :instance_writer => false if kls.superclass == ActiveRecord::Base
    end
  end
end
