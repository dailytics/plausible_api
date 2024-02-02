module PlausibleApi
  class Configuration
    attr_accessor :base_url

    def base_url
      @base_url || "https://plausible.io"
    end
  end
end
