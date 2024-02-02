require "test_helper"

class PlausibleApiClientTest < Minitest::Test
  def test_raises_configuration_error
    assert_raises PlausibleApi::ConfigurationError do
      PlausibleApi.configuration.base_url = nil
      c = PlausibleApi::Client.new("dailytics.com", "token")
      c.aggregate
    end
  end
end