require "test_helper"

class PlausibleApiTimeseriesTest < Minitest::Test
  def test_default_request_url
    timeseries = PlausibleApi::Stats::Timeseries.new
    assert_equal timeseries.request_url, 
      '/api/v1/stats/timeseries?site_id=$SITE_ID&period=30d'
  end
end