# frozen_string_literal: true

require 'strscan'

module LaTeX
  module Decode

    module Maths
      Span = Data.define(:open, :body, :close) do
        def display?
          open == '$$' || open == '\['
        end

        def to_s
          "#{open}#{body}#{close}"
        end
      end

      OPEN = /\$\$|\$|\\\(|\\\[/

      CLOSE = {
        '$$' => '$$',
        '$' => '$',
        '\(' => '\)',
        '\[' => '\]'
      }.freeze

      CLOSE_PATTERNS = CLOSE.transform_values { |close|
        Regexp.new(Regexp.escape(close))
      }.freeze

      class << self
        # Splits the string into text (as Strings) and math (as Spans).
        def split(string)
          segments = []
          text = +''
          unclosed = {}
          scanner = StringScanner.new(string)

          until scanner.eos?
            open = scanner.scan(OPEN)

            if open.nil?
              text << scan_token(scanner)
            elsif !unclosed[open] && (body = scan_body(scanner, CLOSE_PATTERNS[open]))
              segments << text unless text.empty?
              segments << Span.new(open, body, CLOSE[open])
              text = +''
            else
              # If there is no closing delimiter after this one,
              # there is none after any later one either.
              unclosed[open] = true
              text << open
            end
          end

          segments << text unless text.empty?
          segments
        end

        private

        # Returns the math up to the closing delimiter, or nil
        # (leaving the scanner in place) if there is none.
        def scan_body(scanner, close)
          start = scanner.pos
          body = +''

          until scanner.eos?
            return body if scanner.scan(close)
            body << scan_token(scanner)
          end

          scanner.pos = start
          nil
        end

        # Scans an escape sequence, a run of ordinary characters,
        # or a single character.
        def scan_token(scanner)
          scanner.scan(/\\.|[^\\$]+/m) || scanner.getch
        end
      end
    end

  end
end
