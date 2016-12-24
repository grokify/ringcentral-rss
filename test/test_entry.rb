require './test/test_base.rb'
require 'ringcentral-rss'
require 'nokogiri'

class RingCentralRSSEntryTest < Test::Unit::TestCase
  TEST_MESSAGE = {
    'to' => [{ 'phoneNumber' => '+16505551212' }],
    'from' => { 'phoneNumber' => '+14155551212' },
    'subject' => 'hello world!',
    'direction' => 'Inbound',
    'type' => 'SMS',
    'lastModifiedTime' => '2015-01-01T00:00:00+0000'
  }.freeze

  def test_main
    entry = RingCentral::RSS::AtomEntry.new TEST_MESSAGE
    xml = entry.entry.to_xml

    doc = Nokogiri::XML xml
    doc.remove_namespaces!

    doc.xpath('//summary').each do |el|
      assert_equal TEST_MESSAGE['subject'], el.text
    end

    doc.xpath('//title').each do |el|
      assert_equal entry.build_title(TEST_MESSAGE), el.text
    end
  end
end
