#!ruby

require 'sinatra'
require 'multi_json'
require 'ringcentral_sdk'
require 'ringcentral-rss'

set :port, ENV['MY_APP_PORT']

# Enter config in .env file
client = RingCentralSdk::REST::Client.new
config = RingCentralSdk::REST::Config.new.load_dotenv
client.set_app_config config.app
client.authorize_user config.user

get '/' do
  erb :index
end

get '/message-store' do
  res = client.http.get do |req|
    req.url 'account/~/extension/~/message-store'
    req.params = request.params
  end
  response['Content-Type'] = 'application/xml'
  xml = RingCentral::RSS::AtomFeed.new(res).feed.to_xml
end

get '/message-store.json' do
  res = client.http.get do |req|
    req.url 'account/~/extension/~/message-store'
    req.params = request.params
  end
  response['Content-Type'] = 'application/json'
  json = MultiJson.encode res.body, pretty: true
end