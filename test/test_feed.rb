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

  def faraday_client(body)
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/message-store') { [200, TEST_HEADERS, body] }
    end

    Faraday.new do |builder|
      builder.adapter :test, stubs
    end
  end

  def data_for_tests
    body = {
      'uri' => 'https://platform.devtest.ringcentral.com/restapi/v1.0/account/~/extension/~/message-store',
      'records' => [TEST_MESSAGE]
    }

    client = faraday_client body

    res = client.get '/message-store'
    {
      body: body,
      doc: res_to_doc(res),
      res: res
    }
  end

  def res_to_doc(res)
    feed = RingCentral::RSS::AtomFeed.new

    feed.load_message_store_response res

    doc = Nokogiri::XML feed.to_xml
    doc.remove_namespaces!
    doc
  end

  def test_nil
    feed = RingCentral::RSS::AtomFeed.new
    assert_equal nil, feed.to_xml
  end

  def test_main
    test_data = data_for_tests
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
    test_data = data_for_tests

    feed = RingCentral::RSS::AtomFeed.new test_data[:res], feed_name: 'Awesome Feed'
    xml = feed.to_xml
    doc = Nokogiri::XML xml
    doc.remove_namespaces!

    doc.xpath('//feed/title').each do |el|
      assert_equal 'Awesome Feed', el.text
    end
  end
end
