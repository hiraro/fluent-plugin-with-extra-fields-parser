require 'fluent/log'
require 'json'

module Fluent
  class TextParser
    class WithExtraFieldsParser < Parser
      Plugin.register_parser('with_extra_fields', self)

      config_param :base_format, :string
      config_param :suppress_parse_error_log, :bool, :default => false

      def initialize
        super
        @parser = nil
        @extra_fields = {}
      end

      def configure(conf)
        super
        @parser = Plugin.new_parser(@base_format)
        @parser.configure(conf)

        JSON.parse(conf["extra_fields"]).each { |k, v|
          @extra_fields[k] = v
        }
      end

      def parse(text)
        begin
          @parser.parse(text) { |time, record|
            if time && record
              @extra_fields.each { |k, v|
                record[k] = v
              }
              yield time, record
            end
          }
        rescue => e
          $log.warn "parse failed #{e.message}" unless @suppress_parse_error_log
        end
        yield nil, nil
      end
    end
  end
end
