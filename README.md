# Siamese

This gem aims to provide simple SMS message sending with Twilio in Rails, broadly mimicing the ActionMailer API for familiarity.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'siamese'
```

## Usage

Configure in an initializer:
```ruby
# config/initializers/siamese.rb
require "siamese"

Siamese.configure do |config|
  config.twilio_account_sid = Rails.application.credentials[:twilio_account_sid]
  config.twilio_auth_token = Rails.application.credentials[:twilio_auth_token]
  config.defaults = { from: "+18008675309" }
end
```

Make a template:
```erb
<!-- app/views/sms/example.erb -->
Hello <%= context.name %>, welcome!
```

Deliver the message:
```ruby
Siamese.example(context).deliver_now
```

Siamese expects the context to have a `#phone` method to tell it where to send the message, otherwise you can specify it with the `to:` option to the template call.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/siamese.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
