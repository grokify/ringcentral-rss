require './test/test_base.rb'
require 'faraday'
require 'nokogiri'
require 'ringcentral-rss'

class RingCentralRSSFeedTest < Test::Unit::TestCase
  TEST_MESSAGE = {
    'to' => [{ 'phoneNumber' => '+16505551212' }],
    'from' => { 'phoneNumber' => '+14155551212' },
    'subject' => 'hello world!',
    'direction' => 'Inbound',
    'type' => 'SMS',
    'lastModifiedTime' => '2015-01-01T00:00:00+0000'
  }.freeze

  TEST_HEADERS = { 'date' => 'Wed, 09 Nov 2016 06:46:16 GMT' }.freeze

  TEST_XML_TIME = '2016-11-09T06:46:16+00:00'.freeze

  def get_test_feed_main
    body = {
      'uri' => 'https://platform.devtest.ringcentral.com/restapi/v1.0/account/~/extension/~/message-store',
      'records' => [TEST_MESSAGE]
    }

    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/message-store') { [200, TEST_HEADERS, body] }
    end

    test = Faraday.new do |builder|
      builder.adapter :test, stubs
    end

    res = test.get '/message-store'

    feed = RingCentral::RSS::AtomFeed.new
    assert_equal nil, feed.to_xml

    feed.load_message_store_response res

    doc = Nokogiri::XML feed.to_xml
    doc.remove_namespaces!
    {
      body: body,
      doc: doc,
      res: res
    }
  end

  def test_main
    test_data = get_test_feed_main
    doc = test_data[:doc]

    doc.xpath('//feed/link').each do |el|
      assert_equal test_data[:body]['uri'], el.attribute('href').value
    end

    doc.xpath('//feed/title').each do |el|
      assert_equal 'RingCentral Feed', el.text
    end

    doc.xpath('//feed/updated').each do |el|
      assert_equal TEST_XML_TIME, el.text
    end

    doc.xpath('//feed/entry/summary').each do |el|
      assert_equal TEST_MESSAGE['subject'], el.text
    end
  end

  def test_feed_name
    test_data = get_test_feed_main
    
    feed = RingCentral::RSS::AtomFeed.new test_data[:res], feed_name: 'Awesome Feed'
    xml = feed.to_xml
    doc = Nokogiri::XML xml
    doc.remove_namespaces!

    doc.xpath('//feed/title').each do |el|
      assert_equal 'Awesome Feed', el.text
    end
  end
end
