require './test/test_base.rb'
require 'faraday'
require 'nokogiri'
require 'ringcentral-rss'

class RingCentralRSSFeedTest < Test::Unit::TestCase

  def test_main
    headers = {'date' => 'Wed, 09 Nov 2016 06:46:16 GMT'}
    xml_time = '2016-11-09T06:46:16+00:00'

    message = {
      'to' => [{'phoneNumber' => '+16505551212'}],
      'from' => {'phoneNumber' => '+14155551212'},
      'subject' => 'hello world!',
      'direction' => 'Inbound',
      'type' => 'SMS',
      'lastModifiedTime' => '2015-01-01T00:00:00+0000'
    }

    body = {
      'uri' => 'https://platform.devtest.ringcentral.com/restapi/v1.0/account/~/extension/~/message-store',
      'records' => [ message ]
    }

    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/message-store') { [200, headers, body] }
    end

    test = Faraday.new do |builder|
      builder.adapter :test, stubs
    end

    res = test.get '/message-store'

    feed = RingCentral::RSS::AtomFeed.new
    assert_equal nil, feed.to_xml

    feed.load_message_store_response res

    xml = feed.to_xml

    doc = Nokogiri::XML xml
    doc.remove_namespaces!

    doc.xpath('//feed/link').each do |el|
      assert_equal body['uri'], el.attribute('href').value
    end

    doc.xpath('//feed/title').each do |el|
      assert_equal 'RingCentral Feed', el.text
    end

    doc.xpath('//feed/updated').each do |el|
      assert_equal xml_time, el.text
    end

    doc.xpath('//feed/entry/summary').each do |el|
      assert_equal message['subject'], el.text
    end

    feed = RingCentral::RSS::AtomFeed.new res, feed_name: 'Awesome Feed'
    xml = feed.to_xml
    doc = Nokogiri::XML xml
    doc.remove_namespaces!

    doc.xpath('//feed/title').each do |el|
      assert_equal 'Awesome Feed', el.text
    end
  end
end
