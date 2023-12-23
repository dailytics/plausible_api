require 'bundler/setup'
require 'plausible_api'

client = PlausibleApi::Client.new(ENV["SITE_ID"], ENV["TOKEN"])

# default all the things, pointless but works
p client.event

# change the name
p client.event(
  name: "test",
)

# send the whole kitchen sink
p client.event(
  ip: "127.0.0.1",
  user_agent: "test",
  name: "test",
  url: "app://localhost/test",
  referrer: "https://example.com",
  revenue: {currency: "USD", amount: 1.00},
  props: {foo: "bar"},
)
