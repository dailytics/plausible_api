# frozen_string_literal: true

module PlausibleApi
  module Stats
    class Timeseries
      def initialize(options = {})
        @period   = options[:period] || '30d'
        @filters  = options[:filters]
        @interval = options[:interval]
      end

      def request_url
        url = "/api/v1/stats/timeseries?site_id=$SITE_ID"
        url += "&period=#{@period}" if @period
        url += "&filters=#{CGI.escape(@filters)}" if @filters
        url += "&interval=#{@interval}" if @interval
        url
      end
    end
  end
end