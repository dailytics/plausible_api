require "test_helper"

class PlausibleApiConfigurationTest < Minitest::Test
  def test_default_configuration
    PlausibleApi.configuration.base_url = PlausibleApi::Configuration.new.base_url
    assert_equal PlausibleApi.configuration.base_url, "https://plausible.io"
  end

  def test_valid_configuration
    PlausibleApi.configuration.base_url = "https://example.com"
    assert_equal true, PlausibleApi.configuration.valid?
  end

  def test_invalid_configuration_nil
    PlausibleApi.configuration.base_url = nil
    assert_equal false, PlausibleApi.configuration.valid?
  end

  def test_invalid_configuration_non_https
    PlausibleApi.configuration.base_url = "example.com"
    assert_equal false, PlausibleApi.configuration.valid?
  end

  def test_invalid_configuration_trailing_slash
    PlausibleApi.configuration.base_url = "https://example.com/"
    assert_equal false, PlausibleApi.configuration.valid?
  end
end