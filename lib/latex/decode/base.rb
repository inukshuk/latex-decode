# frozen_string_literal: true

module LaTeX
  module Decode

    class Decoder
      class << self
        attr_reader :patterns, :map

        def id
          name.split('::').last.downcase.to_sym
        end

        def decode(string)
          decode!(string.dup)
        end

        def decode!(string)
          patterns.each do |pattern|
            decode_pattern!(string, pattern)
          end
          string
        end

        def decode_pattern!(string, pattern)
          string.gsub!(pattern) { |m| [$2,map[$1],$3].compact.join }
          string
        end
      end
    end

    module Base

      module_function

      def normalize(string)
        string.gsub!(/\\(?:i|j)\b/) { |m| m == '\\i' ? 'ı' : 'ȷ' }

        # \foo\ bar -> \foo{} bar
        string.gsub!(/(\\[a-zA-Z]+)\\(\s+)/, '\1{}\2')

        # Aaaa\o, -> Aaaa\o{},
        string.gsub!(/([^{]\\\w)([;,.:%])/, '\1{}\2')

        # \c cb -> \c{cb}
        string.gsub!(/(\\[^\sij&#\$\{\}_~%])\s+([[:alpha:]]+)\b/i, '\1{\2}')

        # non-breaking spaces
        string.gsub!(/(\A|[^\\])~/, "\\1\u00a0")

        string
      end

      def strip_braces(string)
        string.gsub!(/(^|[^\\])([\{\}]+)/, '\1')
        string.gsub!(/\\(\{|\})/, '\1')
        string
      end

    end

  end
end
