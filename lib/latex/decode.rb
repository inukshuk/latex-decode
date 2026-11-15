# frozen_string_literal: true

require 'latex/decode/version'
require 'latex/decode/compatibility'
require 'latex/decode/base'

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
  ]

  class << self
    attr_reader :decoders

    def decode(string, options = {})
      return string unless string.respond_to?(:to_s)

      string = string.is_a?(String) ? string.dup : string.to_s

      Decode::Base.normalize(string)

      decoders.each do |d|
        d.decode! string unless options[d.id] == false
      end

      Decode::Base.strip_braces(string) unless options[:strip_braces] == false

      LaTeX.normalize_C(string)
    end
  end
end
