# frozen_string_literal: true

module PlausibleApi
  module Stats
    class Aggregate
      def initialize(options = {})
        @period  = options[:period] || '30d'
        @metrics = options[:metrics] || 'visitors,pageviews,bounce_rate,visit_duration'
        @filters  = options[:filters]
        @date    = options[:date]
      end

      def request_url
        url = "/api/v1/stats/aggregate?site_id=$SITE_ID"
        if @period
          url += "&period=#{@period}"
        end
        if @metrics
          url += "&metrics=#{@metrics}"
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