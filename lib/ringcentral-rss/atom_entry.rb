require 'atom'

module RingCentral
  module RSS
    # Represents an Atom Entry for a feed
    class AtomEntry
      attr_accessor :entry

      def initialize(data = nil)
        load_message(data) unless data.nil?
      end

      def load_message(data)
        raise 'Data is not a hash' unless data.is_a? Hash

        @entry = Atom::Entry.new do |e|
          e.title = build_title data
          e.links << Atom::Link.new(href: data['uri'])
          e.id = data['id']
          e.updated = Time.parse(data['lastModifiedTime'])
          e.summary = data['subject']
        end
      end

      def build_title(data)
        raise 'Data is not a hash' unless data.is_a? Hash

        parts = []

        to = to_phone_number data
        parts << "To: #{to}" unless to.empty?

        from = from_phone_number data
        parts << "From: #{from}" unless from.nil?

        "[#{data['direction']} #{data['type']}] " + parts.join('; ')
      end

      def to_phone_number(data, index = 0)
        if data.key?('to') && !data['to'].empty? && data['to'][index]['phoneNumber']
          return data['to'][0]['phoneNumber'].to_s
        end
        nil
      end

      def from_phone_number(data)
        if data.key?('from') && !data['from']['phoneNumber'].empty?
          return data['from']['phoneNumber'].to_s
        end
        nil
      end
    end
  end
end
