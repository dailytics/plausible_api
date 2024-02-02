module PlausibleApi
  class Configuration
    attr_accessor :base_url

    # Setting up default values
    def initialize
      @base_url = "https://plausible.io"
    end
  end
end
