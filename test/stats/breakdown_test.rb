require "test_helper"

class PlausibleApiBreakdownTest < Minitest::Test
  def test_default_parameters
    breakdown = PlausibleApi::Stats::Breakdown.new
    assert_equal breakdown.request_url, 
      '/api/v1/stats/breakdown?site_id=$SITE_ID&period=30d&property=event:page'
  end

  def test_period_parameter
    breakdown = PlausibleApi::Stats::Breakdown.new({ period: '7d' })
    assert_equal breakdown.request_url, 
      '/api/v1/stats/breakdown?site_id=$SITE_ID&period=7d&property=event:page'
  end

  def test_property_parameter
    breakdown = PlausibleApi::Stats::Breakdown.new({ property: 'visit:source' })
    assert_equal breakdown.request_url, 
      '/api/v1/stats/breakdown?site_id=$SITE_ID&period=30d&property=visit:source'
  end

  def test_filters_parameter
    breakdown = PlausibleApi::Stats::Breakdown.new({ filters: 'event:page==/order/confirmation' })
    assert_equal breakdown.request_url, 
      '/api/v1/stats/breakdown?site_id=$SITE_ID&period=30d&filters=event%3Apage%3D%3D%2Forder%2Fconfirmation&property=event:page'
  end

  def test_limit_parameter
    breakdown = PlausibleApi::Stats::Breakdown.new({ limit: 10 })
    assert_equal breakdown.request_url, 
      '/api/v1/stats/breakdown?site_id=$SITE_ID&period=30d&property=event:page&limit=10'
  end

  def test_page_parameter
    breakdown = PlausibleApi::Stats::Breakdown.new({ page: 2 })
    assert_equal breakdown.request_url, 
      '/api/v1/stats/breakdown?site_id=$SITE_ID&period=30d&property=event:page&page=2'
  end

  def test_all_parameters
    breakdown = PlausibleApi::Stats::Breakdown.new({ property: 'visit:source', period: '7d', 
      metrics: 'pageviews', limit: 30, page:1, filters: 'event:page==/order/confirmation' })
    assert_equal breakdown.request_url, 
      '/api/v1/stats/breakdown?site_id=$SITE_ID&period=7d&metrics=pageviews&filters=event%3Apage%3D%3D%2Forder%2Fconfirmation&property=visit:source&limit=30&page=1'
  end
end