require 'rails'

module Html5Validators
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'html5_validators' do |app|
      ActiveSupport.on_load(:active_record) do
        require 'html5_validators/active_model/helper_methods'
        require 'html5_validators/active_model/validations'
        if (Rails.version < '3.1.0.beta2') && (Rails.version != '3.1.0')
          require 'html5_validators/active_model/initializer_monkey_patches'
        end
      end
      ActiveSupport.on_load(:action_view) do
        require 'html5_validators/action_view/form_helpers'
      end
    end
  end
end
