# frozen_string_literal: true

require "plausible_api/utils"
require "plausible_api/api_base"
require "plausible_api/stats/base"
require "plausible_api/stats/realtime/visitors"
require "plausible_api/stats/aggregate"
require "plausible_api/stats/timeseries"
require "plausible_api/stats/breakdown"
require "plausible_api/event/base"
require "plausible_api/event/post"

require "json"
require "net/http"
require "uri"
require "cgi"

module PlausibleApi
  class Client < Utils

    attr_accessor :configuration

    def initialize(site_id: nil, api_key: nil, base_url: nil)
      @configuration = PlausibleApi.configuration
      @configuration.api_key = api_key if present? api_key
      @configuration.site_id = site_id if present? site_id
      @configuration.base_url = base_url if present? base_url
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
      realtime_visitors
      true
    rescue
      false
    end

    def event(options = {})
      call PlausibleApi::Event::Post.new(options.merge(domain: @site_id))
    end

    private

    SUCCESS_CODES = %w[200 202].freeze

    def call(api)
      raise Error, api.errors unless api.valid?
      raise ConfigurationError, configuration.errors unless configuration.valid?

      url = "#{configuration.base_url}#{api.request_path.gsub("$SITE_ID", configuration.site_id)}"
      uri = URI.parse(url)

      req = api.request_class.new(uri.request_uri)
      req.initialize_http_header(api.request_headers)
      req.add_field("authorization", "Bearer #{configuration.api_key}") if api.request_auth?
      req.body = api.request_body if api.request_body?

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      response = http.request(req)

      if SUCCESS_CODES.include?(response.code)
        api.parse_response response.body
      else
        raise Error.new response
      end
    end
  end
end
