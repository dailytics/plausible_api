module PlausibleApi
  class Configuration
    attr_accessor :base_url

    # Setting up default values
    def initialize
      @base_url = "https://plausible.io"
    end

    def valid?
      errors.empty?
    end

    def errors
      errors = []
      if base_url.nil? || base_url.empty?
        errors.push(base_url: "base_url is required")
      elsif !(URI.parse base_url).is_a? URI::HTTP
        errors.push(base_url: "base_url is not a valid URL")
      elsif base_url.end_with?("/")
        errors.push(base_url: "base_url should not end with a trailing slash")
      end
      errors
    end
  end
end
