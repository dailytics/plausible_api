# frozen_string_literal: true

require 'plausible_api/api/stats/realtime/visitors'
require 'plausible_api/api/stats/aggregate'
require 'plausible_api/api/stats/timeseries'

require 'faraday'
require 'json'

module PlausibleApi
  class Client
    
    BASE_URL = 'https://plausible.io'

    def initialize(site_id:, token:)
      @site_id = site_id.to_s
      @token   = token.to_s
    end

    def aggregate(options = {})
      call PlausibleApi::Stats::Aggregate.new(options)
    end

    def timeseries(options = {})
      call PlausibleApi::Stats::Timeseries.new(options)
    end

    def realtime_visitors
      call PlausibleApi::Stats::Realtime::Visitors.new
    end

    private
    def call(api)
      url = "#{BASE_URL}#{api.request_url.gsub('$SITE_ID', @site_id)}"
      puts url
      res = Faraday.get(url) do |req|
        req.headers['Authorization'] = "Bearer #{@token}"
      end
      JSON.parse res.body
    end
  end
end