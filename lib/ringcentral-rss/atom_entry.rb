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

        if data.key?('to') && !data['to'].empty? && data['to'][0]['phoneNumber']
          to_phone_number = data['to'][0]['phoneNumber'].to_s
          parts << "To: #{to_phone_number}" unless to_phone_number.empty?
        end

        if data.key?('from') && !data['from']['phoneNumber'].empty?
          from_phone_number = data['from']['phoneNumber'].to_s
          parts << "From: #{from_phone_number}"
        end

        "[#{data['direction']} #{data['type']}] " + parts.join('; ')
      end
    end
  end
end
