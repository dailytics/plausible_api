require "test_helper"

class PlausibleApiBaseValidationTest < Minitest::Test
  def test_period_validation
    aggregate = PlausibleApi::Stats::Aggregate.new({ period: '3d' })
    assert !aggregate.valid?, aggregate.errors
    aggregate = PlausibleApi::Stats::Aggregate.new({ period: '30d' })
    assert aggregate.valid?, aggregate.errors
  end

  def test_metrics_validation
    aggregate = PlausibleApi::Stats::Aggregate.new({ metrics: 'foo' })
    assert !aggregate.valid?, aggregate.errors
    aggregate = PlausibleApi::Stats::Aggregate.new({ metrics: 'pageviews' })
    assert aggregate.valid?, aggregate.errors
  end

  def test_compare_validation
    aggregate = PlausibleApi::Stats::Aggregate.new({ compare: 'foo' })
    assert !aggregate.valid?, aggregate.errors
    aggregate = PlausibleApi::Stats::Aggregate.new({ compare: 'previous_period' })
    assert aggregate.valid?, aggregate.errors
  end

  def test_interval_validation
    timeseries = PlausibleApi::Stats::Timeseries.new({ interval: 'foo' })
    assert !timeseries.valid?, timeseries.errors
    timeseries = PlausibleApi::Stats::Timeseries.new({ interval: 'month' })
    assert timeseries.valid?, timeseries.errors
  end

  def test_filters_validation
    aggregate = PlausibleApi::Stats::Aggregate.new({ filters: 'foo' })
    assert !aggregate.valid?, aggregate.errors
    aggregate = PlausibleApi::Stats::Aggregate.new({ filters: 'event:page' })
    assert !aggregate.valid?, aggregate.errors
    aggregate = PlausibleApi::Stats::Aggregate.new({ filters: 'event:page=~/foo' })
    assert !aggregate.valid?, aggregate.errors
    aggregate = PlausibleApi::Stats::Aggregate.new({ filters: 'event:page==/foo' })
    assert aggregate.valid?, aggregate.errors
  end

  def test_property_validation
    breakdown = PlausibleApi::Stats::Breakdown.new({ property: 'foo' })
    assert !breakdown.valid?, breakdown.errors
    breakdown = PlausibleApi::Stats::Breakdown.new({ property: 'event:page' })
    assert breakdown.valid?, breakdown.errors
  end

  def test_limit_validation
    breakdown = PlausibleApi::Stats::Breakdown.new({ limit: 'foo' })
    assert !breakdown.valid?, breakdown.errors
    breakdown = PlausibleApi::Stats::Breakdown.new({ limit: 0 })
    assert !breakdown.valid?, breakdown.errors
    breakdown = PlausibleApi::Stats::Breakdown.new({ limit: 1 })
    assert breakdown.valid?, breakdown.errors
  end

  def test_page_validation
    breakdown = PlausibleApi::Stats::Breakdown.new({ page: 'foo' })
    assert !breakdown.valid?, breakdown.errors
    breakdown = PlausibleApi::Stats::Breakdown.new({ page: 0 })
    assert !breakdown.valid?, breakdown.errors
    breakdown = PlausibleApi::Stats::Breakdown.new({ page: 1 })
    assert breakdown.valid?, breakdown.errors
  end

  def test_date_validation
    breakdown = PlausibleApi::Stats::Breakdown.new({ date: 'foo' })
    assert !breakdown.valid?, breakdown.errors
    breakdown = PlausibleApi::Stats::Breakdown.new({ period: 'custom', date: 'foo' })
    assert !breakdown.valid?, breakdown.errors
    breakdown = PlausibleApi::Stats::Breakdown.new({ period: 'custom', date: 'foo,bar' })
    assert !breakdown.valid?, breakdown.errors
    breakdown = PlausibleApi::Stats::Breakdown.new({ period: 'custom', date: '2021-01-01,bar' })
    assert !breakdown.valid?, breakdown.errors
    breakdown = PlausibleApi::Stats::Breakdown.new({ period: 'custom', date: '2021-01-01,2021-01-30' })
    assert breakdown.valid?, breakdown.errors
  end
end