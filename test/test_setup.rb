require './test/test_base.rb'
require 'ringcentral-rss'

class RingCentralRSSTest < Test::Unit::TestCase

  def test_main
    feed = RingCentral::RSS::AtomFeed.new
    assert_equal 'RingCentral::RSS::AtomFeed', feed.class.name

    entry = RingCentral::RSS::AtomEntry.new
    assert_equal 'RingCentral::RSS::AtomEntry', entry.class.name
  end
end
