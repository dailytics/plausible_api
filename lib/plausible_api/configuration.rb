module PlausibleApi
  class Configuration
    attr_accessor :base_url, :default_user_agent, :api_key, :site_id

    # Setting up default values
    def initialize
      @base_url = "https://plausible.io"
      @default_user_agent = "plausible_api_ruby/#{PlausibleApi::VERSION}"
      @api_key = nil
      @site_id = nil
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
      if api_key.nil? || api_key.empty?
        errors.push(api_key: "api_key is required")
      end
      if site_id.nil? || site_id.empty?
        errors.push(site_id: "site_id is required")
      end
      errors
    end
  end
end
