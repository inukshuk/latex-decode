# frozen_string_literal: true

require 'latex/decode/version'
require 'latex/decode/compatibility'
require 'latex/decode/base'
require 'latex/decode/maths'

require 'latex/decode/accents'
require 'latex/decode/diacritics'
require 'latex/decode/punctuation'
require 'latex/decode/symbols'
require 'latex/decode/greek'

module LaTeX

  @decoders = [
    Decode::Accents,
    Decode::Diacritics,
    Decode::Punctuation,
    Decode::Symbols,
    Decode::Greek
  ].freeze

  class << self
    attr_reader :decoders

    def decode(string, options = {})
      return string unless string.respond_to?(:to_s)

      decoded = Decode::Maths.split(string.to_s).map { |segment|
        segment.is_a?(Decode::Maths::Span) ? segment.to_s : decode_text(segment, options)
      }.join

      LaTeX.normalize_C(decoded)
    end

    private

    def decode_text(string, options)
      Decode::Base.normalize(string)

      decoders.each do |d|
        d.decode! string unless options[d.id] == false
      end

      Decode::Base.strip_braces(string) unless options[:strip_braces] == false

      string
    end
  end
end
