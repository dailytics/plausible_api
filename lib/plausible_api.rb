require "plausible_api/version"
require "plausible_api/client"
require "plausible_api/configuration"

module PlausibleApi
  class Error < StandardError; end

  class ConfigurationError < StandardError; end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
