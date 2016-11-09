require './test/test_base.rb'
require 'ringcentral-rss'
require 'nokogiri'

class RingCentralRSSEntryTest < Test::Unit::TestCase

  def test_main
    message = {
      'to' => [{'phoneNumber' => '+16505551212'}],
      'from' => {'phoneNumber' => '+14155551212'},
      'subject' => 'hello world!',
      'direction' => 'Inbound',
      'type' => 'SMS',
      'lastModifiedTime' => '2015-01-01T00:00:00+0000'
    }

    entry = RingCentral::RSS::AtomEntry.new message
    xml = entry.entry.to_xml

    doc = Nokogiri::XML xml
    doc.remove_namespaces!

    doc.xpath('//summary').each do |el|
      assert_equal message['subject'], el.text
    end

    doc.xpath('//title').each do |el|
      assert_equal entry.build_title(message), el.text
    end
  end
end
