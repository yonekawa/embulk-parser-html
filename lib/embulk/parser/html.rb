require 'nokogiri'

module Embulk
  module Parser

    class Html < ParserPlugin
      Plugin.register_parser('html', self)

      def self.transaction(config, &control)
        schema = config.param('schema', :array)
        task = {
          'schema' => schema.each_with_object({}) {|s, memo|
            memo[s['name']] = { 'type' => s['type'], 'xpath' => s['xpath'] }
            if s['type'] == 'timestamp'
              memo[s['name']].merge!({
                'format' => s['format'],
                'timezone' => s['timezone'] || "+0900"
              })
            end
          }
        }

        columns = schema.each_with_index.map do |s, i|
          Column.new(i, s['xpath'], s['type'].to_sym)
        end

        yield(task, columns)
      end

      def init
        @schema = task['schema']
      end

      def run(file_input)
        while file = file_input.next_file
          data = file.read
          if !data.nil? && !data.empty?
            parse(data).each do |record|
              page_builder.add(record)
            end
          end
        end

        page_builder.finish
      end

      private

      def parse(data)
        doc = Nokogiri::HTML(data)
        @schema.each_with_object([]) do |(name, config), records|
          doc.xpath(config['xpath']).each_with_index do |item, i|
            records[i] ||= []
            records[i] << convert(item.text, config)
          end
        end
      end

      def convert(val, config)
        v = val || ''
        case config['type']
        when 'string'
          v
        when 'long'
          v.to_i
        when 'double'
          v.to_f
        when 'boolean'
          ['yes', 'true', '1'].include?(v.downcase)
        when 'timestamp'
          unless v.empty?
            dest = Time.strptime(v, config['format'])
            utc_offset = dest.utc_offset
            zone_offset = Time.zone_offset(config['timezone'])
            dest.localtime(zone_offset) + utc_offset - zone_offset
          end
        else
          raise "Unsupported type '#{type}'"
        end
      end
    end
  end
end
