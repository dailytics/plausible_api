require "test_helper"

class PlausibleApiClientTest < Minitest::Test
  def test_initialize_with_parameters
    c = PlausibleApi::Client.new(site_id: "dailytics.com", api_key: "token", base_url: "https://example.com")
    assert_equal "dailytics.com", c.configuration.site_id
    assert_equal "token", c.configuration.api_key
    assert_equal "https://example.com", c.configuration.base_url
  end

  def test_initialize_with_configuration
    PlausibleApi.configure do |config|
      config.base_url = "https://example.com"
      config.api_key = "token"
      config.site_id = "dailytics.com"
    end
    c = PlausibleApi::Client.new
    assert_equal "dailytics.com", c.configuration.site_id
    assert_equal "token", c.configuration.api_key
    assert_equal "https://example.com", c.configuration.base_url
  end

  def test_raises_configuration_error
    assert_raises PlausibleApi::ConfigurationError do
      PlausibleApi.configuration.base_url = nil
      c = PlausibleApi::Client.new
      c.aggregate
    end
  end
end