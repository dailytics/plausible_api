require "test_helper"

class PlausibleApiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PlausibleApi::VERSION
  end
end
