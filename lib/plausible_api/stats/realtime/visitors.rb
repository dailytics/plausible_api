# frozen_string_literal: true

module PlausibleApi 
  module Stats
    module Realtime
      class Visitors
        def initialize
        end

        def request_url
          "/api/v1/stats/realtime/visitors?site_id=$SITE_ID"
        end

        def parse_response(body)
          body.to_i
        end
      end
    end
  end
end