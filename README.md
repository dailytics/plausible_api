# Plausible API Ruby Gem
This is a simple wrapper to read the Plausible API with Ruby.
It's based on the WIP [API guide](https://plausible.io/docs/stats-api)

## Usage
Add this gem to your Gemfile:
```rb
gem 'plausible_api'
```
Then you need to initialize a Client with your `site_id` (the domain) and your `token`.
```rb
c = PlausibleApi::Client.new('dailytics.com', '123123') 

# Test if the site and token are valid
c.valid?
=> true
```

### Stats > Aggregate

You have all these options to get the aggregate stats
```rb
# Use the default parameters (3mo period + the 4 main metrics)
c.aggregate

# Set parameters (period, metrics, filter, compare)
c.aggregate({ period: '30d' })
c.aggregate({ period: '30d', metrics: 'visitors,pageviews' })
c.aggregate({ period: '30d', metrics: 'visitors,pageviews', filters: 'event:page==/order/confirmation' })
c.aggregate({ date: '2021-01-01,2021-02-10' })

# You'll get something like this:
=> {"bounce_rate"=>{"value"=>81.0}, "pageviews"=>{"value"=>29}, "visit_duration"=>{"value"=>247.0}, "visitors"=>{"value"=>14}}
```

### Stats > Timeseries

You have all these options to get the timeseries
```rb
# Use the default parameters (3mo period)
c.timeseries

# Set parameters (period, filters, interval)
c.timeseries({ period: '7d' })
c.timeseries({ period: '7d', filters: 'event:page==/order/confirmation' })
c.timeseries({ date: '2021-01-01,2021-02-15' })

# You'll get something like this:
=> [{"date"=>"2021-01-11", "value"=>100}, {"date"=>"2021-01-12", "value"=>120}, {"date"=>"2021-01-13", "value"=>80}...]
```

### Stats > Breakdown
```rb
# Use the default parameters (30d, event:page)
c.breakdown

# Set parameters (property, period, metrics, limit, page, filters, date)
c.breakdown({ property: 'visit:source' })
c.breakdown({ property: 'visit:source', metrics: 'visitors,pageviews' })
c.breakdown({ property: 'visit:source', metrics: 'visitors,pageviews', period: '30d' })
c.breakdown({ property: 'visit:source', metrics: 'visitors,pageviews', date: '2021-01-01,2021-02-01' })

# You'll get something like this:
=> [{"page"=>"/", "visitors"=>41}, {"page"=>"/plans/", "visitors"=>14}, {"page"=>"/agencies/", "visitors"=>8}, {"page"=>"/features/", "visitors"=>8}, {"page"=>"/ready/", "visitors"=>5}, {"page"=>"/contact/", "visitors"=>4}, {"page"=>"/about/", "visitors"=>3}, {"page"=>"/donate/", "visitors"=>3}]
```

### Realtime > Visitors

It's as simple as:
```rb
c.realtime_visitors

=> 13
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dailytics/plausible_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/dailytics/plausible_api/blob/main/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PlausibleApi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/dailytics/plausible_api/blob/main/CODE_OF_CONDUCT.md).
