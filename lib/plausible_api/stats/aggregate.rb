# frozen_string_literal: true

module PlausibleApi
  module Stats
    class Aggregate < Base
      def initialize(options = {})
        super({period: "30d",
               metrics: "visitors,visits,pageviews,views_per_visit,bounce_rate,visit_duration,events"}
          .merge(options))
      end

      def request_path_base
        "/api/v1/stats/aggregate?site_id=$SITE_ID"
      end
    end
  end
end
