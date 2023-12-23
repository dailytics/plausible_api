# frozen_string_literal: true

module PlausibleApi
  module Stats
    class Event < Base
      DEFAULT_USER_AGENT = "plausible_api_ruby/#{PlausibleApi::VERSION}"

      attr_reader :domain
      attr_reader :ip, :user_agent, :url
      attr_reader :name, :props, :referrer, :revenue

      def initialize(options = {})
        @options = options.transform_keys(&:to_sym)

        @domain = maybe_string(@options[:domain])
        @ip = maybe_string(@options[:ip])
        @user_agent = maybe_string(@options[:user_agent], default: DEFAULT_USER_AGENT)

        @name = maybe_string(@options[:name], default: "pageview")
        @url = maybe_string(@options[:url], default: "app://localhost/#{@name}")
        @referrer = maybe_string(@options[:referrer])

        @revenue = @options[:revenue]
        @props = @options[:props]
      end

      def request_class
        Net::HTTP::Post
      end

      def request_url_base
        "/api/event"
      end

      def request_url
        request_url_base
      end

      def request_auth?
        false
      end

      def request_body?
        true
      end

      def request_body
        data = {
          url: @url,
          name: @name,
          domain: @domain,
        }

        data[:props] = @props if present?(@props)
        data[:revenue] = @revenue if present?(@revenue)
        data[:referrer] = @referrer if present?(@referrer)

        JSON.generate(data)
      end

      def request_headers
        headers = {
          'content-type' => 'application/json',
          'user-agent' => @user_agent,
        }
        headers['x-forwarded-for'] = @ip if present?(@ip)
        headers
      end

      def parse_response(body)
        body == "ok"
      end

      VALID_REVENUE_KEYS = [:amount, :currency].freeze

      def errors
        errors = []
        errors.push(url: "url is required") if blank?(@url)
        errors.push(name: "name is required") if blank?(@name)
        errors.push(domain: "domain is required") if blank?(@domain)
        errors.push(user_agent: "user_agent is required") if blank?(@user_agent)

        if present?(@revenue)
          if @revenue.is_a?(Hash)
            unless valid_revenue_keys?(@revenue)
              errors.push(
                revenue: "revenue must have keys #{VALID_REVENUE_KEYS.join(', ')} " +
                         "but was #{@revenue.inspect}",
              )
            end
          else
            errors.push(revenue: "revenue must be a Hash")
          end
        end

        if present?(@props) && !@props.is_a?(Hash)
          errors.push(props: "props must be a Hash")
        end

        errors
      end

      private

      def valid_revenue_keys?(revenue)
        revenue.keys.sort.map(&:to_sym) == VALID_REVENUE_KEYS.sort
      end

      def present?(value)
        !value.nil? && !value.empty?
      end

      def blank?(value)
        !present?(value)
      end

      def maybe_string(value, default: nil)
        return default if value.nil?
        value = value.to_s.strip
        value.empty? ? default : value
      end
    end
  end
end
