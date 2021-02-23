# frozen_string_literal: true

module PlausibleApi
  module Stats
    class Base
      def initialize(options = {})
        raise NotImplementedError
      end

      def request_url_base
        raise NotImplementedError
      end

      def request_url
        url = request_url_base
        url += "&period=#{@period}" if defined?(@period) && @period
        url += "&metrics=#{@metrics}" if defined?(@metrics) && @metrics
        url += "&filters=#{CGI.escape(@filters)}" if defined?(@filters) && @filters
        url += "&compare=#{@compare}" if defined?(@compare) && @compare
        url += "&interval=#{@interval}" if defined?(@interval) && @interval
        url += "&property=#{@property}" if defined?(@property) && @property
        url += "&limit=#{@limit}" if defined?(@limit) && @limit
        url += "&page=#{@page}" if defined?(@page) && @page
        url
      end

      def parse_response(body)
        raise NotImplementedError
      end

      def valid?
        errors.empty?
      end

      def errors  
        allowed_period   = %w(12mo 6mo month 30d 7d day custom)
        allowed_metrics  = %w(visitors pageviews bounce_rate visit_duration)
        allowed_compare  = %w(previous_period)
        allowed_interval = %w(date month)
        allowed_property = %w(event:page event:source event:referrer event:utm_medium 
          event:utm_source event:utm_campaign event:device event:browser event:browser_version 
          event:os event:os_version event:country)
        e = 'Not a valid parameter. Allowed parameters are: '
        
        errors = []
        if defined?(@period) && !@period.nil?
          errors.push({ period: "#{e}#{allowed_period.join(', ')}" }) unless allowed_period.include? @period
        end
        if defined?(@metrics) && !@metrics.nil?
          metrics_array = @metrics.split(',') 
          errors.push({ metrics: "#{e}#{allowed_metrics.join(', ')}" }) unless metrics_array & allowed_metrics == metrics_array
        end
        if defined?(@compare) && !@compare.nil?
          errors.push({ compare: "#{e}#{allowed_compare.join(', ')}" }) unless allowed_compare.include? @compare
        end
        if defined?(@interval) && !@interval.nil?
          errors.push({ interval: "#{e}#{allowed_interval.join(', ')}" }) unless allowed_interval.include? @interval
        end
        if defined?(@property) && !@property.nil?
          errors.push({ property: "#{e}#{allowed_property.join(', ')}" }) unless allowed_property.include? @property
        end
        if defined?(@filters) && !@filters.nil?
          filters_array = @filters.to_s.split(';')
          filters_array.each do |f|
            parts = f.split("==")
            errors.push({ filters: "Unrecognized filter: #{f}" }) unless parts.length == 2
            errors.push({ filters: "Unknown metric for filter: #{parts[0]}" }) unless allowed_property.include? parts[0]
          end
        end
        if defined?(@limit) && !@limit.nil?
          errors.push({ limit: "Limit param must be a positive number" }) unless @limit.is_a? Integer and @limit > 0
        end
        if defined?(@page) && !@page.nil?
          errors.push({ page: "Page param must be a positive number" }) unless @page.is_a? Integer and @page > 0
        end
        errors
      end
    end
  end
end