require 'bundler/setup'
require 'plausible_api'

client = PlausibleApi::Client.new(ENV["SITE_ID"], ENV["TOKEN"])
p client.valid?
