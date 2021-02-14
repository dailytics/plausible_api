require "test_helper"

class PlausibleApiTimeseriesTest < Minitest::Test
  def test_default_parameters
    timeseries = PlausibleApi::Stats::Timeseries.new
    assert_equal timeseries.request_url, 
      '/api/v1/stats/timeseries?site_id=$SITE_ID&period=30d'
  end

  def test_period_parameter
    timeseries = PlausibleApi::Stats::Timeseries.new({ period: '7d' })
    assert_equal timeseries.request_url, 
      '/api/v1/stats/timeseries?site_id=$SITE_ID&period=7d'
  end

  def test_filters_parameter
    timeseries = PlausibleApi::Stats::Timeseries.new({ filters: 'event:page==/order/confirmation' })
    assert_equal timeseries.request_url, 
      '/api/v1/stats/timeseries?site_id=$SITE_ID&period=30d&filters=event%3Apage%3D%3D%2Forder%2Fconfirmation'
  end

  def test_interval_parameter
    timeseries = PlausibleApi::Stats::Timeseries.new({ interval: 'month' })
    assert_equal timeseries.request_url, 
      '/api/v1/stats/timeseries?site_id=$SITE_ID&period=30d&interval=month'
  end

  def test_all_parameters
    timeseries = PlausibleApi::Stats::Timeseries.new({ period: '7d', filters: 'event:page==/order/confirmation', interval: 'month' })
    assert_equal timeseries.request_url, 
      '/api/v1/stats/timeseries?site_id=$SITE_ID&period=7d&filters=event%3Apage%3D%3D%2Forder%2Fconfirmation&interval=month'
  end
end