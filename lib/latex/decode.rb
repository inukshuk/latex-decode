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

      Decode::Accents.decode!(string)
      Decode::Diacritics.decode!(string)
      
      string
    end
  end
end