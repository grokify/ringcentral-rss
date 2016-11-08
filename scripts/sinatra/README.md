RingCentral RSS Sinatra Example
===============================

This is a simple Sinatra service that will render RingCentral `message-store` API endpoint in XML and JSON.

## Installation

```bash
$ git clone https://github.com/ringcentral-ruby/ringcentral-rss-ruby
$ cd ringcentral-rss-ruby/scripts
$ bundle
$ cp config-sample.env.txt .env
$ vi .env
```

## Usage

```bash
$ ruby app.rb
```

Open your browser and go to the URL specified by `ruby app.rb`.