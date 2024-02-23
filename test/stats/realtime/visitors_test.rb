require "test_helper"

class PlausibleApiRealtimeVisitorsTest < Minitest::Test
  def test_default_parameters
    visitors = PlausibleApi::Stats::Realtime::Visitors.new
    assert_equal visitors.request_path,
      "/api/v1/stats/realtime/visitors?site_id=$SITE_ID"
  end
end