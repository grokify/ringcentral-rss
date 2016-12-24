require 'atom'

module RingCentral
  module RSS
    class AtomFeed
      attr_accessor :feed

      def initialize(response = nil, opts = {})
        if opts.key?(:feed_name) && opts[:feed_name]
          @feed_name = opts[:feed_name]
        else
          @feed_name = 'RingCentral Feed'
        end
        @feed = nil
        load_message_store_response(response) unless response.nil?
      end

      def load_message_store_response(response)
        @feed = Atom::Feed.new do |f|
          f.title = @feed_name
          f.links << Atom::Link.new(href: response.body['uri'].to_s)
          f.updated = Time.parse(response.headers['date'].to_s)
          response.body['records'].each do |message|
            f.entries << RingCentral::RSS::AtomEntry.new(message).entry
          end
        end
      end

      def to_xml
        (!@feed.nil? && @feed.is_a?(Atom::Feed)) ? @feed.to_xml : nil
      end
    end
  end
end
