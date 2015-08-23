module Html5Validators
  class << self
    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end
  end

  class Configuration
    include ActiveSupport::Configurable

    config_accessor :validation
  end

  configure do |config|
    config.validation = {
      :required  => true,
      :maxlength => true,
      :minlength => true,
      :max       => true,
      :min       => true
    }
  end
end
