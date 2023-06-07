# frozen_string_literal: true

module PlausibleApi
  module Stats
    class Base

      def initialize(options = {})
        @options = { compare: nil, date: nil, filters: nil, interval: nil,
                      limit: nil, metrics: nil, page: nil, period: nil,
                      property: nil }.merge(options)
        @options[:period] = 'custom' if @options[:date]
      end

      def request_url_base
        raise NotImplementedError
      end

      def request_url
        params = @options.select{ |_,v| !v.to_s.empty? }
        [request_url_base, URI.encode_www_form(params)].reject{|e| e.empty?}.join('&')
      end

      def parse_response(body)
        raise NotImplementedError
      end

      def valid?
        errors.empty?
      end

      def errors
        allowed_period   = %w(12mo 6mo month 30d 7d day custom)
        allowed_metrics  = %w(visitors visits pageviews views_per_visit bounce_rate visit_duration events)
        allowed_compare  = %w(previous_period)
        allowed_interval = %w(date month)
        allowed_property = %w(event:page visit:entry_page visit:exit_page visit:source visit:referrer
          visit:utm_medium visit:utm_source visit:utm_campaign visit:device visit:browser
          visit:browser_version visit:os visit:os_version visit:country)
        e = 'Not a valid parameter. Allowed parameters are: '

        errors = []
        if @options[:period]
          errors.push({ period: "#{e}#{allowed_period.join(', ')}" }) unless allowed_period.include? @options[:period]
        end
        if @options[:metrics]
          metrics_array = @options[:metrics].split(',')
          errors.push({ metrics: "#{e}#{allowed_metrics.join(', ')}" }) unless metrics_array & allowed_metrics == metrics_array
        end
        if @options[:compare]
          errors.push({ compare: "#{e}#{allowed_compare.join(', ')}" }) unless allowed_compare.include? @options[:compare]
        end
        if @options[:interval]
          errors.push({ interval: "#{e}#{allowed_interval.join(', ')}" }) unless allowed_interval.include? @options[:interval]
        end
        if @options[:property]
          errors.push({ property: "#{e}#{allowed_property.join(', ')}" }) unless allowed_property.include? @options[:property]
        end
        if @options[:filters]
          filters_array = @options[:filters].to_s.split(';')
          filters_array.each do |f|
            parts = f.split("==")
            errors.push({ filters: "Unrecognized filter: #{f}" }) unless parts.length == 2
            errors.push({ filters: "Unknown metric for filter: #{parts[0]}" }) unless allowed_property.include? parts[0]
          end
        end
        if @options[:limit]
          errors.push({ limit: "Limit param must be a positive number" }) unless @options[:limit].is_a? Integer and @options[:limit] > 0
        end
        if @options[:page]
          errors.push({ page: "Page param must be a positive number" }) unless @options[:page].is_a? Integer and @options[:page] > 0
        end
        if @options[:date]
          errors.push({ date: 'You must define the period parameter as custom' }) unless @options[:period] == 'custom'
          date_array = @options[:date].split(",")
          errors.push({ date: 'You must define start and end dates divided by comma' }) unless date_array.length == 2
          regex = /\d{4}\-\d{2}\-\d{2}/
          errors.push({ date: 'Wrong format for the start date' }) unless date_array[0] =~ regex
          errors.push({ date: 'Wrong format for the end date' }) unless date_array[1] =~ regex
        end
        errors
      end
    end
  end
end
