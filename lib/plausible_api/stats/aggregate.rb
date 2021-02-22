# frozen_string_literal: true

module PlausibleApi
  module Stats
    class Aggregate
      def initialize(options = {})
        @period  = options[:period] || '30d'
        @metrics = options[:metrics] || 'visitors,pageviews,bounce_rate,visit_duration'
        @filters = options[:filters]
        @compare = options[:compare]
      end

      def request_url
        url = "/api/v1/stats/aggregate?site_id=$SITE_ID"
        url += "&period=#{@period}" if @period
        url += "&metrics=#{@metrics}" if @metrics
        url += "&filters=#{CGI.escape(@filters)}" if @filters
        url += "&compare=#{@compare}" if @compare
        url
      end

      def parse_response(body)
        JSON.parse body
      end
    end
  end
end