# frozen_string_literal: true

require 'latex/decode/version'
require 'latex/decode/compatibility'
require 'latex/decode/base'

require 'latex/decode/accents'
require 'latex/decode/diacritics'
require 'latex/decode/punctuation'
require 'latex/decode/symbols'
require 'latex/decode/greek'
require 'latex/decode/maths'

module LaTeX

  NBSP = 0xA0.chr(Encoding::UTF_8).freeze

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
        if segment.is_a?(Decode::Maths::Span)
          options[:math] == false ? segment.to_s : Decode::Maths.to_unicode(segment)
        else
          decode_text(segment, options)
        end
      }.join

      # ASCII is always in NFC.
      decoded.ascii_only? ? decoded : LaTeX.normalize_C(decoded)
    end

    private

    def decode_text(string, options)
      return decode_plain_text(string, options) unless string.include?('\\')

      Decode::Base.normalize(string)

      decoders.each do |d|
        d.decode! string unless options[d.id] == false
      end

      Decode::Base.strip_braces(string) unless options[:strip_braces] == false

      string
    end

    # Without a backslash, only non-breaking spaces, dash and quote
    # ligatures and braces can be decoded; this is equivalent to,
    # but much faster than, the full decode_text.
    def decode_plain_text(string, options)
      string.tr!('~', NBSP)
      Decode::Punctuation.decode_ligatures!(string) unless options[:punctuation] == false
      string.delete!('{}') unless options[:strip_braces] == false
      string
    end
  end
end
