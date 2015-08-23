require 'rails'
require 'html5_validators/config'

module Html5Validators
  @enabled = true

  def self.enabled
    @enabled
  end

  def self.enabled=(enable)
    @enabled = enable
  end

  class << self
    def validation_enabled?(validation, object)
      enabled && config.validation[validation] &&
        object.class.ancestors.include?(ActiveModel::Validations) &&
        !(object.auto_html5_validation == false || object.auto_html5_validation.try(:[], validation) == false) &&
        !(object.class.auto_html5_validation == false || object.class.auto_html5_validation.try(:[], validation) == false)
    end
  end

  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'html5_validators' do |app|
      ActiveSupport.on_load(:active_record) do
        require 'html5_validators/active_model/helper_methods'
        require 'html5_validators/active_model/validations'
        if (Rails.version < '3.1.0.beta2') && (Rails.version != '3.1.0')
          require 'html5_validators/active_model/initializer_monkey_patches'
        end
        require 'html5_validators/active_record/base'
      end
      ActiveSupport.on_load(:action_view) do
        if ActionPack::VERSION::STRING >= '4'
          if RUBY_VERSION > '2'
            require 'html5_validators/action_view/form_helpers'
          else
            require 'html5_validators/action_view/form_helpers_ruby1'
          end
        else
          require 'html5_validators/action_view/form_helpers_rails3'
        end
      end
    end
  end
end
