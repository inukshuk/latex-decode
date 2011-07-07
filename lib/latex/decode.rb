# coding: utf-8

require 'unicode'

require 'latex/decode/version'
require 'latex/decode/decoder'
require 'latex/decode/accents'
require 'latex/decode/diacritics'

module LaTeX
  class << self
    def decode (string)
      return string unless string.is_a? String

      puts string
      Decode::Accents.decode!(string)
      puts string
      Decode::Diacritics.decode!(string)
      puts string
      
      string
      # Unicode::normalize_C(string) 
    end
  end
end