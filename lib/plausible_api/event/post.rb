# frozen_string_literal: true

module PlausibleApi
  module Event
    class Post < Base
      DEFAULT_USER_AGENT = "plausible_api_ruby/#{PlausibleApi::VERSION}"
      VALID_REVENUE_KEYS = %i[amount currency].freeze
      OPTIONS_IN_HEADERS = %i[ip user_agent].freeze

      attr_reader :domain
      attr_reader :ip, :user_agent, :url
      attr_reader :name, :props, :referrer, :revenue

      def initialize(options = {})
        @options = options.transform_keys(&:to_sym)

        @domain = @options[:domain]
        @ip = @options[:ip]
        @user_agent = presence(@options[:user_agent]) || DEFAULT_USER_AGENT
        @name = presence(@options[:name]) || "pageview"
        @url = presence(@options[:url]) || "app://localhost/#{@name}"
        @referrer = @options[:referrer]
        @revenue = @options[:revenue]
        @props = @options[:props]
      end

      def request_body
        data = {
          url: @url,
          name: @name,
          domain: @domain
        }

        data[:props] = @props if present?(@props)
        data[:revenue] = @revenue if present?(@revenue)
        data[:referrer] = @referrer if present?(@referrer)

        JSON.generate(data)
      end

      def request_headers
        headers = {
          "content-type" => "application/json",
          "user-agent" => @user_agent
        }
        headers["x-forwarded-for"] = @ip if present?(@ip)
        headers
      end

      def parse_response(body)
        body == "ok"
      end

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
                revenue: "revenue must have keys #{VALID_REVENUE_KEYS.join(", ")} " \
                         "but was #{@revenue.inspect}"
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

      def presence(value)
        return nil if blank?(value)
        value
      end
    end
  end
end
