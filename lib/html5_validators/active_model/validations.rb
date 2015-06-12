module Html5Validators
  module ActiveModelExtension
    extend ActiveSupport::Concern

    included do
      cattr_accessor :auto_html5_validation, :instance_accessor => false, :instance_reader => false, :instance_writer => false
    end
  end
end

module ActiveModel
  module Validations
    attr_accessor :auto_html5_validation
  end
end

ActiveModel::Validations.send(:include, Html5Validators::ActiveModelExtension)
