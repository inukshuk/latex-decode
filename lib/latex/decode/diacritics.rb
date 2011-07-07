# -*- coding: utf-8 -*-

module LaTeX
  module Decode
    
    class Diacritics < Decoder
      @map = Hash[*%W{
        r \u030A
        H \u030B
        u \u0306
        v \u030C
        G \u030F
        M \u0322
        d \u0323
        c \u0327
        k \u0328
        b \u0331
        B \u0335
        t \u0311
      }].freeze

      @pattern = /\\(#{ map.keys.map { |k| Regexp.escape(k) }.join('|') })\{([^}]*)\}/ou
    end
    
  end
end