module PlausibleApi
  module Event
    class Base
      DEFAULT_USER_AGENT = "plausible_api_ruby/#{PlausibleApi::VERSION}"

      def request_class
        Net::HTTP::Post
      end

      def request_url_base
        "/api/event"
      end

      def request_url
        request_url_base
      end

      def request_auth?
        false
      end

      def request_body?
        true
      end

      def valid?
        errors.empty?
      end
    end
  end
end
