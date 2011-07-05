# coding: utf-8

require 'latex/decode/version'

module LaTeX
  class << self
    def decode (string)
      return string unless string.is_a? String
      
      string.gsub(/\\"a/, 'ä').gsub(/\\"o/, 'ö').gsub(/\\"u/, 'ü')
    end
  end
end