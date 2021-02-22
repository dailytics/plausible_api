# frozen_string_literal: true

module PlausibleApi
  module Stats
    class Base
      def initialize(options = {})
        raise NotImplementedError
      end

      def request_url_base
        raise NotImplementedError
      end

      def request_url
        url = request_url_base
        url += "&period=#{@period}" if @period
        url += "&metrics=#{@metrics}" if @metrics
        url += "&filters=#{CGI.escape(@filters)}" if @filters
        url += "&compare=#{@compare}" if @compare
        url += "&interval=#{@interval}" if @interval
        url += "&property=#{@property}" if @property
        url += "&limit=#{@limit}" if @limit
        url += "&page=#{@page}" if @page
        url
      end

      def parse_response(body)
        raise NotImplementedError
      end
    end
  end
end