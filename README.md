RingCentral RSS
===============

[![Gem Version][gem-version-svg]][gem-version-link]
[![Build Status][build-status-svg]][build-status-link]
[![Coverage Status][coverage-status-svg]][coverage-status-link]
[![Dependency Status][dependency-status-svg]][dependency-status-link]
[![Code Climate][codeclimate-status-svg]][codeclimate-status-link]
[![Scrutinizer Code Quality][scrutinizer-status-svg]][scrutinizer-status-link]
[![Downloads][downloads-svg]][downloads-link]
[![Docs][docs-rubydoc-svg]][docs-rubydoc-link]
[![License][license-svg]][license-link]

Ruby library to create XML syndication feeds for RingCentral `message-store` REST API responses.

This library was originally created in response to a question on (archiving RingCentral SMS data using Smarsh via a RSS feed](https://devcommunity.ringcentral.com/ringcentraldev/topics/archive-sms-using-rss).

## Usage

```ruby
client = RingCentralSdk.new [...]
client.authorize [...]

res = client.http.get do |req|
  req.url = 'account/~/extension/~/message-store'
  req.params['direction'] = 'Outbound'
  req.params['messageType'] = 'SMS'
end

rc_feed = RingCentral::RSS::AtomFeed.new res
xml = rc_feed.feed.to_xml

xml = RingCentral::RSS::AtomFeed.new(res).feed.to_xml
```

## Demo Scripts

Demo scripts are located in the [`scripts` directory of the GitHub repo](https://github.com/ringcentral-ruby/ringcentral-rss-ruby/tree/master/scripts). The following demos are included:

* CLI script to retrieve `message-store` endpoint and print out XML
* Sinatra web service to display XML

### Change Log

See [CHANGELOG.md](CHANGELOG.md)

## Links

Project Repo

* https://github.com/ringcentral-ruby/ringcentral-rss

RingCentral API Docs

* https://developers.ringcentral.com/library.html

RingCentral Official SDKs

* https://github.com/ringcentral

## Contributing

1. Fork it ( http://github.com/ringcentral-ruby/ringcentral-rss/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

RingCentral RSS is available under an MIT-style license. See [LICENSE.md](LICENSE.md) for details.

RingCentral RSS &copy; 2016 by John Wang

 [gem-version-svg]: https://badge.fury.io/rb/ringcentral-rss.svg
 [gem-version-link]: http://badge.fury.io/rb/ringcentral-rss
 [downloads-svg]: http://ruby-gem-downloads-badge.herokuapp.com/ringcentral-rss
 [downloads-link]: https://rubygems.org/gems/ringcentral-rss
 [build-status-svg]: https://api.travis-ci.org/ringcentral-ruby/ringcentral-rss-ruby.svg?branch=master
 [build-status-link]: https://travis-ci.org/ringcentral-ruby/ringcentral-rss-ruby
 [coverage-status-svg]: https://coveralls.io/repos/ringcentral-ruby/ringcentral-rss-ruby/badge.svg?branch=master
 [coverage-status-link]: https://coveralls.io/r/ringcentral-ruby/ringcentral-rss-ruby?branch=master
 [dependency-status-svg]: https://gemnasium.com/ringcentral-ruby/ringcentral-rss-ruby.svg
 [dependency-status-link]: https://gemnasium.com/ringcentral-ruby/ringcentral-rss-ruby
 [codeclimate-status-svg]: https://codeclimate.com/github/ringcentral-ruby/ringcentral-rss-ruby/badges/gpa.svg
 [codeclimate-status-link]: https://codeclimate.com/github/ringcentral-ruby/ringcentral-rss-ruby
 [scrutinizer-status-svg]: https://scrutinizer-ci.com/g/ringcentral-ruby/ringcentral-rss-ruby/badges/quality-score.png?b=master
 [scrutinizer-status-link]: https://scrutinizer-ci.com/g/ringcentral-ruby/ringcentral-rss-ruby/?branch=master
 [docs-rubydoc-svg]: https://img.shields.io/badge/docs-rubydoc-blue.svg
 [docs-rubydoc-link]: http://www.rubydoc.info/gems/ringcentral-rss/
 [license-svg]: https://img.shields.io/badge/license-MIT-blue.svg
 [license-link]: https://github.com/ringcentral-ruby/ringcentral-rss-ruby/blob/master/LICENSE.md
