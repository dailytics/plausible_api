# Plausible API (Work In Progress)
This is a simple wrapper to read the Plausible API with Ruby.
It's based on the WIP [API guide](https://plausible.io/docs/stats-api)

## Usage
Add this gem to your Gemfile:
```rb
gem 'plausible_api'
```
Then you need to initialize a Client with your `site_id` (the domain) and your `token`.
```rb
c = PlausibleApi::Client.new(site_id: 'dailytics.com', token: '123123')
```

### Stats > Aggregate

You have all these options to get the aggregate stats
```rb
# Use the default parameters (3mo period + the 4 main metrics)
c.aggregate

# Set parameters (period, metrics, filter, date)
c.aggregate({ period: '3d' })
c.aggregate({ period: '3d', metrics: 'visitors,pageviews' })
c.aggregate({ period: '3d', metrics: 'visitors,pageviews', filter: 'event:page==/order/confirmation' })

# You'll get something like this:
=> {"bounce_rate"=>{"value"=>81.0}, "pageviews"=>{"value"=>29}, "visit_duration"=>{"value"=>247.0}, "visitors"=>{"value"=>14}}
```

### Stats > Timeseries

You have all these options to get the timeseries
```rb
# Use the default parameters (3mo period)
c.timeseries

# Set parameters (period, metrics, filter, date)
c.timeseries({ period: '3d' })
c.timeseries({ period: '3d', filter: 'event:page==/order/confirmation', date: '2020/02/10' })

# You'll get something like this:
=> [{"date"=>"2021-01-11", "value"=>100}, {"date"=>"2021-01-12", "value"=>120}, {"date"=>"2021-01-13", "value"=>80}]
```

### Realtime >> Visitors

You have a uniq way to call this data
```rb
c.realtime_visitors
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dailytics/plausible_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/dailytics/plausible_api/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PlausibleApi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/dailytics/plausible_api/blob/master/CODE_OF_CONDUCT.md).
