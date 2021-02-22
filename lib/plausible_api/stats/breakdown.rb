# frozen_string_literal: true

module PlausibleApi
  module Stats
    class Breakdown < Base
      def initialize(options = {})
        @property = options[:property] || 'event:page' # required
        @period  = options[:period] || '30d' # required
        @metrics = options[:metrics]
        @limit   = options[:limit]
        @page    = options[:page]
        @filters = options[:filters]
      end

      def request_url_base
        "/api/v1/stats/breakdown?site_id=$SITE_ID"
      end

      def parse_response(body)
        JSON.parse(body)['results']
      end
    end
  end
end