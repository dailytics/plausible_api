require "test_helper"

class PlausibleApiEventPostTest < Minitest::Test
  def setup
    @options = {
      domain: "example.com"
    }
  end

  def test_initialize
    event = PlausibleApi::Event::Post.new(@options)
    assert_equal "pageview", event.name
    assert_equal "example.com", event.domain
    assert_equal "app://localhost/pageview", event.url
    assert_equal "plausible_api_ruby/#{PlausibleApi::VERSION}", event.user_agent

    assert_nil event.ip
    assert_nil event.props
    assert_nil event.revenue
    assert_nil event.referrer
  end

  def test_request_class
    event = PlausibleApi::Event::Post.new(@options)
    assert_equal Net::HTTP::Post, event.request_class
  end

  def test_request_url_base
    event = PlausibleApi::Event::Post.new(@options)
    assert_equal event.request_path, "/api/event"
  end

  def test_request_body_predicate
    event = PlausibleApi::Event::Post.new(@options)
    assert_predicate event, :request_body?
  end

  def test_request_auth_predicate
    event = PlausibleApi::Event::Post.new(@options)
    refute_predicate event, :request_auth?
  end

  def test_request_body
    event = PlausibleApi::Event::Post.new(@options)
    expected = {
      "name" => "pageview",
      "domain" => "example.com",
      "url" => "app://localhost/pageview"
    }
    assert_equal expected, JSON.parse(event.request_body)
  end

  def test_request_body_with_referrer
    @options[:referrer] = "https://johnnunemaker.com"
    event = PlausibleApi::Event::Post.new(@options)
    expected = {
      "name" => "pageview",
      "domain" => "example.com",
      "url" => "app://localhost/pageview",
      "referrer" => "https://johnnunemaker.com"
    }
    assert_equal expected, JSON.parse(event.request_body)
  end

  def test_request_body_with_revenue
    @options[:revenue] = {currency: "USD", amount: 1322.22}
    event = PlausibleApi::Event::Post.new(@options)
    expected = {
      "name" => "pageview",
      "domain" => "example.com",
      "url" => "app://localhost/pageview",
      "revenue" => {"currency" => "USD", "amount" => 1322.22}
    }
    assert_equal expected, JSON.parse(event.request_body)
  end

  def test_request_body_with_props
    @options[:props] = {test: "ing"}
    event = PlausibleApi::Event::Post.new(@options)
    expected = {
      "name" => "pageview",
      "domain" => "example.com",
      "url" => "app://localhost/pageview",
      "props" => {"test" => "ing"}
    }
    assert_equal expected, JSON.parse(event.request_body)
  end

  def test_request_headers
    event = PlausibleApi::Event::Post.new(@options)
    expected = {
      "content-type" => "application/json",
      "user-agent" => "plausible_api_ruby/#{PlausibleApi::VERSION}"
    }
    assert_equal expected, event.request_headers
  end

  def test_request_headers_with_ip
    @options[:ip] = "127.0.0.1"
    event = PlausibleApi::Event::Post.new(@options)
    expected = {
      "content-type" => "application/json",
      "user-agent" => "plausible_api_ruby/#{PlausibleApi::VERSION}",
      "x-forwarded-for" => "127.0.0.1"
    }
    assert_equal expected, event.request_headers
  end

  def test_parse_response
    event = PlausibleApi::Event::Post.new(@options)
    assert event.parse_response("ok")
    refute event.parse_response("blah")
  end

  def test_valid
    event = PlausibleApi::Event::Post.new(@options)
    assert_predicate event, :valid?
  end

  def test_valid_with_all_options
    @options.update({
      user_agent: "Something Else",
      ip: "127.0.0.1",
      revenue: {currency: "USD", amount: 1322.22},
      props: {test: "ing"},
      referrer: "https://johnnunemaker.com"
    })
    event = PlausibleApi::Event::Post.new(@options)
    assert_predicate event, :valid?, event.errors
  end

  def test_errors_domain_required
    @options.delete(:domain)
    event = PlausibleApi::Event::Post.new(@options)
    assert_equal [domain: "domain is required"], event.errors
  end

  def test_errors_user_agent_defaults_no_matter_what
    @options.delete(:user_agent)
    event = PlausibleApi::Event::Post.new(@options)
    assert_equal [], event.errors
    assert_equal "plausible_api_ruby/#{PlausibleApi::VERSION}", event.user_agent
  end

  def test_errors_revenue_not_hash
    @options[:revenue] = "foo"
    event = PlausibleApi::Event::Post.new(@options)
    assert_equal [revenue: "revenue must be a Hash"], event.errors
  end

  def test_errors_revenue_hash_with_wrong_keys
    @options[:revenue] = {foo: "bar"}
    event = PlausibleApi::Event::Post.new(@options)
    assert_equal [revenue: "revenue must have keys amount, currency but was {:foo=>\"bar\"}"], event.errors
  end

  def test_errors_props_not_hash
    @options[:props] = "foo"
    event = PlausibleApi::Event::Post.new(@options)
    assert_equal [props: "props must be a Hash"], event.errors
  end
end
