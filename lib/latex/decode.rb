# coding: utf-8

require 'unicode'

require 'latex/decode/version'
require 'latex/decode/base'

module LaTeX
  
  class << self
    def decode (string)
      return string unless string.is_a? String

      string = string.dup
      
      Decode::Base.normalize(string)
      
      Decode::Accents.decode!(string)
      Decode::Diacritics.decode!(string)
      Decode::Punctuation.decode!(string)
      Decode::Symbols.decode!(string)
      
      Decode::Base.strip_braces(string)
      
      Unicode::normalize_C(string)
    end
  end
end