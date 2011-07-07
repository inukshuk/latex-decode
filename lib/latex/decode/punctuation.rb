# -*- coding: utf-8 -*-

module LaTeX
  module Decode
    
    class Punctuation < Decoder
      @map = Hash[*%W{
        textendash         \u2013
        textemdash         \u2014
        textquoteleft      \u2018
        textquoteright     \u2019
        quotesinglbase     \u201A
        textquotedblleft   \u201C
        textquotedblright  \u201D
        quotedblbase       \u201E
        dag                \u2020
        ddag               \u2021
        textbullet         \u2022
        dots               \u2026
        textperthousand    \u2030
        textpertenthousand \u2031
        guilsinglleft      \u2039
        guilsinglright     \u203A
        textreferencemark  \u203B
        textinterrobang    \u203D
        textoverline       \u203E
        langle             \u27E8
        rangle             \u27E9
      }].freeze

      @pattern = /\\(#{ map.keys.map { |k| Regexp.escape(k) }.join('|') })(?:\{\}|\s+|\b)/ou
    end

  end
end