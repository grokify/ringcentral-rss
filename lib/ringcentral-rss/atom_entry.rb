require 'atom'

module RingCentral
  module RSS
    class AtomEntry
      attr_accessor :entry

      def initialize(data = nil)
        load_message(data) unless data.nil?
      end

      def load_message(data)
        unless data.is_a?(Hash)
          raise 'Data is not a hash'
        end

        @entry = Atom::Entry.new do |e|
          e.title = build_title data
          e.links << Atom::Link.new(href: data['uri'])
          e.id = data['id']
          e.updated = Time.parse(data['lastModifiedTime'])
          e.summary = data['subject']
        end
      end

      def build_title(data)
        unless data.is_a?(Hash)
          raise 'Data is not a hash'
        end

        parts = []

        if data.key?('to') && (data['to'].length > 0) && data['to'][0]['phoneNumber']
          to_phone_number = "#{data['to'][0]['phoneNumber']}"
          if to_phone_number.length > 0
            parts << "To: #{to_phone_number}"
          end
        end

        if data.key?('from') && data['from']['phoneNumber'].length > 0
          from_phone_number = "#{data['from']['phoneNumber']}"
          parts << "From: #{from_phone_number}"
        end

        "[#{data['direction']} #{data['type']}] " + parts.join('; ')
      end
    end
  end
end