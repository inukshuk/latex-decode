# -*- coding: utf-8 -*-

module LaTeX
  module Decode
    
    class Accents < Decoder
      @map = Hash[*%W{
        `  \u0300
        '  \u0301
        ^  \u0302
        ~  \u0303
        =  \u0304
        .  \u0307
        '' \u0308
        "  \u0308  
      }].freeze

      @pattern = /\\(#{ map.keys.join('|') })\{([^}]*)\}/ou
    end

  end
end