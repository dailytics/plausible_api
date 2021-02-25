require "test_helper"

class PlausibleApiBreakdownTest < Minitest::Test
  def test_default_parameters
    breakdown = PlausibleApi::Stats::Breakdown.new
    assert_equal breakdown.request_url, 
      '/api/v1/stats/breakdown?site_id=$SITE_ID&period=30d&property=event%3Apage'
  end

  def test_period_parameter
    breakdown = PlausibleApi::Stats::Breakdown.new({ period: '7d' })
    assert_equal breakdown.request_url, 
      '/api/v1/stats/breakdown?site_id=$SITE_ID&period=7d&property=event%3Apage'
  end

  def test_property_parameter
    breakdown = PlausibleApi::Stats::Breakdown.new({ property: 'visit:source' })
    assert_equal breakdown.request_url, 
      '/api/v1/stats/breakdown?site_id=$SITE_ID&period=30d&property=visit%3Asource'
  end

  def test_filters_parameter
    breakdown = PlausibleApi::Stats::Breakdown.new({ filters: 'event:page==/order/confirmation' })
    assert_equal breakdown.request_url, 
      '/api/v1/stats/breakdown?site_id=$SITE_ID&filters=event%3Apage%3D%3D%2Forder%2Fconfirmation&period=30d&property=event%3Apage'
  end

  def test_empty_filters_parameter
    breakdown = PlausibleApi::Stats::Breakdown.new({ filters: '' })
    assert_equal breakdown.request_url, 
      '/api/v1/stats/breakdown?site_id=$SITE_ID&period=30d&property=event%3Apage'
  end

  def test_limit_parameter
    breakdown = PlausibleApi::Stats::Breakdown.new({ limit: 10 })
    assert_equal breakdown.request_url, 
      '/api/v1/stats/breakdown?site_id=$SITE_ID&limit=10&period=30d&property=event%3Apage'
  end

  def test_page_parameter
    breakdown = PlausibleApi::Stats::Breakdown.new({ page: 2 })
    assert_equal breakdown.request_url, 
      '/api/v1/stats/breakdown?site_id=$SITE_ID&page=2&period=30d&property=event%3Apage'
  end

  def test_date_parameter
    breakdown = PlausibleApi::Stats::Breakdown.new({ period: 'custom', date: '2021-01-01,2021-01-31' })
    assert_equal breakdown.request_url, 
      '/api/v1/stats/breakdown?site_id=$SITE_ID&date=2021-01-01%2C2021-01-31&period=custom&property=event%3Apage'
  end

  def test_all_parameters
    breakdown = PlausibleApi::Stats::Breakdown.new({ property: 'visit:source', period: '7d', 
      metrics: 'pageviews', limit: 30, page:1, filters: 'event:page==/order/confirmation' })
    assert_equal breakdown.request_url, 
      '/api/v1/stats/breakdown?site_id=$SITE_ID&filters=event%3Apage%3D%3D%2Forder%2Fconfirmation&limit=30&metrics=pageviews&page=1&period=7d&property=visit%3Asource'
  end
end