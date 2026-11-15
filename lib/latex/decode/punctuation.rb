# frozen_string_literal: true

module LaTeX
  module Decode

    class Punctuation < Decoder

      @macros = Hash[*%w{
        textendash         –
        textemdash         —
        textquoteleft      ‘
        textquoteright     ’
        quotesinglbase     ‚
        textquotedblleft   “
        textquotedblright  ”
        quotedblbase       „
        dag                †
        ddag               ‡
        textbullet         •
        dots               …
        textperthousand    ‰
        textpertenthousand ‱
        guilsinglleft      ‹
        guilsinglright     ›
        textreferencemark  ※
        textinterrobang    ‽
        textoverline       ‾
        langle             ⟨
        rangle             ⟩
        textasciicircum    ^
        textbackslash      \\
        textasciitilde     ~
        textquotesingle    '
      }].freeze

      @symbols = Hash[*%w[
        -     -
        --    –
        ---   —
        ``    “
        `     ‘
        ''    ”
        '     ’
      ]].freeze

      @map = @macros.merge(@symbols).freeze

      # Dash and quote ligatures, the only punctuation without a backslash.
      LIGATURES = /(-+|`{1,2}|'{1,2})/

      @patterns = [
        /\\(#{ @macros.keys.map { |k| Regexp.escape(k) }.compact.join('|') })(?:\{\}|\s+|\b|$)/ou,
        LIGATURES,
        /()\\([$%;#_&])(\{\})?/,
        /()\\(~)\{\}/,
        /()\\( )/
      ].freeze

      def self.decode_ligatures!(string)
        decode_pattern!(string, LIGATURES)
      end

    end

  end
end
