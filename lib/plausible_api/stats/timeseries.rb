# frozen_string_literal: true

module PlausibleApi
  module Stats
    class Timeseries
      def initialize(options = {})
        @period = options[:period] || '30d'
        @filters = options[:filters]
        @date   = options[:date]
      end

      def request_url
        url = "/api/v1/stats/timeseries?site_id=$SITE_ID"
        if @period
          url += "&period=#{@period}"
        end
        if @filters
          url += "&filters=#{CGI.escape(@filters)}"
        end
        if @date
          url += "&date=#{@date}"
        end
        url
      end
    end
  end
end