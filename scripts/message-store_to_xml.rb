#!ruby

require 'ringcentral-rss'
require 'ringcentral_sdk'
require 'pp'

# Set your credentials in the .env file
# Use the rc_config_sample.env.txt file as a scaffold

config = RingCentralSdk::REST::Config.new.load_dotenv

client = RingCentralSdk::REST::Client.new
client.set_app_config config.app
client.authorize_user config.user

res = client.http.get do |req|
  req.url 'account/~/extension/~/message-store'
  req.params['direction'] = 'Inbound'
  req.params['messageType'] = 'SMS'
  req.params['dateFrom'] = '2016-01-01T00:00:00Z'
  req.headers['Accept'] = 'application/xml'
end

atom = RingCentral::RSS::AtomFeed.new res
puts atom.feed.to_xml

puts "DONE"
