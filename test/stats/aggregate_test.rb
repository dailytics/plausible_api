require "test_helper"

class PlausibleApiAggregateTest < Minitest::Test
  def test_default_request_url
    aggregate = PlausibleApi::Stats::Aggregate.new
    assert_equal aggregate.request_url, 
      '/api/v1/stats/aggregate?site_id=$SITE_ID&period=30d&metrics=visitors,pageviews,bounce_rate,visit_duration'
  end
end
