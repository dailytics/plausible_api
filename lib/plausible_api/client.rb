# frozen_string_literal: true

require 'plausible_api/stats/base'
require 'plausible_api/stats/realtime/visitors'
require 'plausible_api/stats/aggregate'
require 'plausible_api/stats/timeseries'
require 'plausible_api/stats/breakdown'

require 'json'
require "net/http"
require "uri"
require "cgi"

module PlausibleApi
  class Client
    
    BASE_URL = 'https://plausible.io'

    def initialize(site_id, token)
      @site_id = site_id.to_s
      @token   = token.to_s
    end

    def aggregate(options = {})
      call PlausibleApi::Stats::Aggregate.new(options)
    end

    def timeseries(options = {})
      call PlausibleApi::Stats::Timeseries.new(options)
    end

    def breakdown(options = {})
      call PlausibleApi::Stats::Breakdown.new(options)
    end

    def realtime_visitors
      call PlausibleApi::Stats::Realtime::Visitors.new
    end

    def valid?
      begin
        realtime_visitors
        return true
      rescue
        return false
      end
    end

    private
    def call(api)      
      raise StandardError.new api.errors unless api.valid?
      
      url = "#{BASE_URL}#{api.request_url.gsub('$SITE_ID', @site_id)}"
      uri = URI.parse(url)

      req = Net::HTTP::Get.new(uri.request_uri)
      req.add_field('Authorization', "Bearer #{@token}")

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true  

      response = http.request(req)

      if response.code == "200"
        api.parse_response response.body
      else
        raise StandardError.new response.body
      end
    end
  end
end