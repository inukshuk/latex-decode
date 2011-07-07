# coding: utf-8

require 'unicode'

require 'latex/decode/version'
require 'latex/decode/decoder'

module LaTeX
  
  module Decode
    autoload :Accents, 'latex/decode/accents'
    autoload :Diacritics, 'latex/decode/diacritics'
    autoload :Punctuation, 'latex/decode/punctuation'
    autoload :Symbols, 'latex/decode/symbols'
  end

  class << self
    def decode (string)
      return string unless string.is_a? String

      Decode::Accents.decode!(string)
      Decode::Diacritics.decode!(string)
      Decode::Punctuation.decode!(string)
      Decode::Symbols.decode!(string)
      
      Unicode::normalize_C(string)
    end
  end
end