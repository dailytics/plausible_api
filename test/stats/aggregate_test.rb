require "test_helper"

class PlausibleApiAggregateTest < Minitest::Test
  def test_default_parameters
    aggregate = PlausibleApi::Stats::Aggregate.new
    assert_equal aggregate.request_url, 
      '/api/v1/stats/aggregate?site_id=$SITE_ID&metrics=visitors%2Cpageviews%2Cbounce_rate%2Cvisit_duration&period=30d'
  end

  def test_period_parameter
    aggregate = PlausibleApi::Stats::Aggregate.new({ period: '7d' })
    assert_equal aggregate.request_url,
      '/api/v1/stats/aggregate?site_id=$SITE_ID&metrics=visitors%2Cpageviews%2Cbounce_rate%2Cvisit_duration&period=7d'
  end

  def test_metrics_parameter
    aggregate = PlausibleApi::Stats::Aggregate.new({ metrics: 'visitors' })
    assert_equal aggregate.request_url,
      '/api/v1/stats/aggregate?site_id=$SITE_ID&metrics=visitors&period=30d'
  end

  def test_filters_parameter
    aggregate = PlausibleApi::Stats::Aggregate.new({ filters: 'event:page==/order/confirmation' })
    assert_equal aggregate.request_url,
      '/api/v1/stats/aggregate?site_id=$SITE_ID&filters=event%3Apage%3D%3D%2Forder%2Fconfirmation&metrics=visitors%2Cpageviews%2Cbounce_rate%2Cvisit_duration&period=30d'
  end

  def test_compare_parameter
    aggregate = PlausibleApi::Stats::Aggregate.new({ compare: 'previous_period' })
    assert_equal aggregate.request_url,
      '/api/v1/stats/aggregate?site_id=$SITE_ID&compare=previous_period&metrics=visitors%2Cpageviews%2Cbounce_rate%2Cvisit_duration&period=30d'
  end

  def test_all_parameters
    aggregate = PlausibleApi::Stats::Aggregate.new({ period: '7d', metrics: 'visitors', filters: 'event:page==/order/confirmation', compare: 'previous_period' })
    assert_equal aggregate.request_url,
      '/api/v1/stats/aggregate?site_id=$SITE_ID&compare=previous_period&filters=event%3Apage%3D%3D%2Forder%2Fconfirmation&metrics=visitors&period=7d'
  end
end
