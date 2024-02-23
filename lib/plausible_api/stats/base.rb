# frozen_string_literal: true

module PlausibleApi
  module Stats
    class Base < ApiBase
      ALLOWED_PERIODS = %w[12mo 6mo month 30d 7d day custom]
      ALLOWED_METRICS = %w[visitors visits pageviews views_per_visit bounce_rate visit_duration events]
      ALLOWED_COMPARE = %w[previous_period]
      ALLOWED_INTERVALS = %w[date month]
      ALLOWED_PROPERTIES = %w[event:goal event:page visit:entry_page visit:exit_page visit:source
        visit:referrer visit:utm_medium visit:utm_source visit:utm_campaign
        visit:utm_content visit:utm_term visit:device visit:browser
        visit:browser_version visit:os visit:os_version visit:country visit:region visit:city
        event:props:.+]
      ALLOWED_FILTER_OPERATORS = %w[== != \|]

      def initialize(options = {})
        @options = {compare: nil, date: nil, filters: nil, interval: nil,
                    limit: nil, metrics: nil, page: nil, period: nil,
                    property: nil}.merge(options)
        @options[:period] = "custom" if @options[:date]
      end

      def request_class
        Net::HTTP::Get
      end

      def request_path
        params = @options.select { |_, v| !v.to_s.empty? }
        [request_path_base, URI.encode_www_form(params)].reject { |e| e.empty? }.join("&")
      end

      def parse_response(body)
        JSON.parse(body)["results"]
      end

      def errors
        e = "Not a valid parameter. Allowed parameters are: "

        errors = []
        if @options[:period]
          errors.push({period: "#{e}#{ALLOWED_PERIODS.join(", ")}"}) unless ALLOWED_PERIODS.include? @options[:period]
        end
        if @options[:metrics]
          metrics_array = @options[:metrics].split(",")
          errors.push({metrics: "#{e}#{ALLOWED_METRICS.join(", ")}"}) unless metrics_array & ALLOWED_METRICS == metrics_array
        end
        if @options[:compare]
          errors.push({compare: "#{e}#{ALLOWED_COMPARE.join(", ")}"}) unless ALLOWED_COMPARE.include? @options[:compare]
        end
        if @options[:interval]
          errors.push({interval: "#{e}#{ALLOWED_INTERVALS.join(", ")}"}) unless ALLOWED_INTERVALS.include? @options[:interval]
        end
        if @options[:property]
          unless @options[:property].match?(/^(#{ALLOWED_PROPERTIES.join('|')})$/)
            errors.push({property: "#{e}#{ALLOWED_PROPERTIES.join(", ")}"}) unless ALLOWED_PROPERTIES.include? @options[:property]
          end
        end
        @options[:filters]&.split(";")&.each do |filter|
          unless filter.match?(/^(#{ALLOWED_PROPERTIES.join('|')})(#{ALLOWED_FILTER_OPERATORS.join('|')})(.+)$/)
            errors.push({filters: "Filter #{filter} is not valid"})
          end
        end

        if @options[:limit]
          errors.push({limit: "Limit param must be a positive number"}) unless @options[:limit].to_i > 0
        end
        if @options[:page]
          errors.push({page: "Page param must be a positive number"}) unless @options[:page].to_i > 0
        end
        if @options[:date]
          errors.push({date: "You must define the period parameter as custom"}) unless @options[:period] == "custom"
          date_array = @options[:date].split(",")
          errors.push({date: "You must define start and end dates divided by comma"}) unless date_array.length == 2
          regex = /\d{4}-\d{2}-\d{2}/
          errors.push({date: "Wrong format for the start date"}) unless date_array[0]&.match?(regex)
          errors.push({date: "Wrong format for the end date"}) unless date_array[1]&.match?(regex)
        end
        errors
      end
    end
  end
end
