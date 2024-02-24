module PlausibleApi
  module Event
    class Base < ApiBase
      def request_class
        Net::HTTP::Post
      end

      def request_path
        "/api/event"
      end

      def request_auth?
        false
      end
    end
  end
end
