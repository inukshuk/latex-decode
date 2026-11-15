# frozen_string_literal: true

require 'strscan'

module LaTeX
  module Decode

    module Maths
      Span = Data.define(:open, :body, :close) do
        def display?
          open == '$$' || open == '\['
        end

        def to_s
          "#{open}#{body}#{close}"
        end
      end

      OPEN = /\$\$|\$|\\\(|\\\[/

      CLOSE = {
        '$$' => '$$',
        '$' => '$',
        '\(' => '\)',
        '\[' => '\]'
      }.freeze

      CLOSE_PATTERNS = CLOSE.transform_values { |close|
        Regexp.new(Regexp.escape(close))
      }.freeze

      class << self
        # Converts the span to Unicode, or returns the original TeX
        # if any part of it cannot be converted.
        def to_unicode(span)
          Converter.convert(span.body) || span.to_s
        end

        # Splits the string into text (as Strings) and math (as Spans).
        def split(string)
          segments = []
          text = +''
          unclosed = {}
          scanner = StringScanner.new(string)

          until scanner.eos?
            open = scanner.scan(OPEN)

            if open.nil?
              text << scan_token(scanner)
            elsif !unclosed[open] && (body = scan_body(scanner, CLOSE_PATTERNS[open]))
              segments << text unless text.empty?
              segments << Span.new(open, body, CLOSE[open])
              text = +''
            else
              # If there is no closing delimiter after this one,
              # there is none after any later one either.
              unclosed[open] = true
              text << open
            end
          end

          segments << text unless text.empty?
          segments
        end

        private

        # Returns the math up to the closing delimiter, or nil
        # (leaving the scanner in place) if there is none.
        def scan_body(scanner, close)
          start = scanner.pos
          body = +''

          until scanner.eos?
            return body if scanner.scan(close)
            body << scan_token(scanner)
          end

          scanner.pos = start
          nil
        end

        # Scans an escape sequence, a run of ordinary characters,
        # or a single character.
        def scan_token(scanner)
          scanner.scan(/\\.|[^\\$]+/m) || scanner.getch
        end
      end

      class Converter
        Unsupported = Class.new(StandardError)

        SYMBOLS = Hash[*%W{
          times          ×
          pm             ±
          div            ÷
          to             →
          gets           ←
          mapsto         ↦
          implies        ⟹
          iff            ⟺
          le             ≤
          ge             ≥
          ne             ≠
          neg            ¬
          lnot           ¬
          land           ∧
          lor            ∨
          perp           ⊥
          ell            ℓ
          hbar           ℏ
          aleph          ℵ
          wp             ℘
          Re             ℜ
          Im             ℑ
          emptyset       ∅
          varnothing     ∅
          prime          ′
          dagger         †
          ddagger        ‡
          ldots          …
          dots           …
          langle         ⟨
          rangle         ⟩
          vert           |
          Vert           ‖
          colon          :
          varepsilon     ε
          vartheta       ϑ
          varphi         φ
          varpi          ϖ
          varrho         ϱ
          varsigma       ς
          varGamma       Γ
          varDelta       Δ
          varTheta       Θ
          varLambda      Λ
          varXi          Ξ
          varPi          Π
          varSigma       Σ
          varUpsilon     Υ
          varPhi         Φ
          varPsi         Ψ
          varOmega       Ω
          circledR       ®
        }].merge(Symbols.map, Greek.map, 'backslash' => '\\').freeze

        FUNCTIONS = %w{
          arccos arcsin arctan arg cos cosh cot coth csc deg det dim exp gcd
          hom inf ker lg lim liminf limsup ln log max min Pr sec sin sinh sup
          tan tanh mod
        }.to_h { |name| [name, name] }.merge('bmod' => 'mod').freeze

        # Style commands that change nothing in Unicode.
        STYLES = %w{
          displaystyle textstyle scriptstyle scriptscriptstyle limits nolimits
        }.freeze

        CONTROL_SYMBOLS = Hash[*%W{
          \{ {
          \} }
          $  $
          %  %
          &  &
          #  #
          _  _
          |  ‖
        }].merge(
          ',' => "\u202F",
          ':' => "\u205F",
          '>' => "\u205F",
          ';' => "\u2004",
          '!' => '',
          ' ' => ' '
        ).freeze

        SPACES = {
          'quad' => "\u2003",
          'qquad' => "\u2003\u2003"
        }.freeze

        # Spacing commands absorb adjacent ordinary spaces.
        SPACING = / ?([\u202F\u205F\u2004\u2003]+) ?/

        FRACTIONS = %w{frac dfrac tfrac}.freeze

        VULGAR_FRACTIONS = Hash[*%w{
          1/2 ½  1/3 ⅓  2/3 ⅔  1/4 ¼  3/4 ¾  1/5 ⅕  2/5 ⅖  3/5 ⅗  4/5 ⅘
          1/6 ⅙  5/6 ⅚  1/7 ⅐  1/8 ⅛  3/8 ⅜  5/8 ⅝  7/8 ⅞  1/9 ⅑  1/10 ⅒
        }].freeze

        # Numerators and denominators containing these need parentheses.
        COMPOUND = /[\s+−±∓×÷·\/=<>≤≥,]/

        ROOTS = { nil => '√', '2' => '√', '3' => '∛', '4' => '∜' }.freeze

        # Combining marks for accents on a single symbol.
        ACCENTS = {
          'acute' => 0x0301, 'bar' => 0x0304, 'breve' => 0x0306,
          'check' => 0x030C, 'ddot' => 0x0308, 'dot' => 0x0307,
          'grave' => 0x0300, 'hat' => 0x0302, 'mathring' => 0x030A,
          'tilde' => 0x0303, 'vec' => 0x20D7, 'widehat' => 0x0302,
          'widetilde' => 0x0303
        }.transform_values { |code| code.chr(Encoding::UTF_8) }.freeze

        # Combining marks applied to every symbol.
        LINES = {
          'overline' => 0x0305, 'underline' => 0x0332
        }.transform_values { |code| code.chr(Encoding::UTF_8) }.freeze

        DELIMITER_SIZES = %w{
          left right middle big Big bigg Bigg bigl Bigl biggl Biggl
          bigr Bigr biggr Biggr bigm Bigm biggm Biggm
        }.freeze

        PRIMES = { 1 => '′', 2 => '″', 3 => '‴' }.freeze

        SUPERSCRIPTS = {
          '0123456789+−=()' => '⁰¹²³⁴⁵⁶⁷⁸⁹⁺⁻⁼⁽⁾',
          'abcdefghijklmnoprstuvwxyz' => 'ᵃᵇᶜᵈᵉᶠᵍʰⁱʲᵏˡᵐⁿᵒᵖʳˢᵗᵘᵛʷˣʸᶻ',
          'ABDEGHIJKLMNOPRTUVW' => 'ᴬᴮᴰᴱᴳᴴᴵᴶᴷᴸᴹᴺᴼᴾᴿᵀᵁⱽᵂ',
          'αβγδθιφχ' => 'ᵅᵝᵞᵟᶿᶥᵠᵡ',
          '′″‴*∗∘†‡' => '′″‴**°†‡'
        }.flat_map { |from, to| from.chars.zip(to.chars) }.to_h.freeze

        SUBSCRIPTS = {
          '0123456789+−=()' => '₀₁₂₃₄₅₆₇₈₉₊₋₌₍₎',
          'aehijklmnoprstuvx' => 'ₐₑₕᵢⱼₖₗₘₙₒₚᵣₛₜᵤᵥₓ',
          'βγρφχ' => 'ᵦᵧᵨᵩᵪ'
        }.flat_map { |from, to| from.chars.zip(to.chars) }.to_h.freeze

        SCRIPTS = (SUPERSCRIPTS.values + SUBSCRIPTS.values).uniq.join.freeze

        # Builds a Mathematical Alphanumeric Symbols alphabet from the
        # code points of 'A', 'a' and '0'; letters Unicode encodes
        # elsewhere (e.g., ℝ) are given as exceptions.
        def self.alphabet(upper, lower, digits = nil, exceptions = '')
          ranges = { ('A'..'Z') => upper, ('a'..'z') => lower, ('0'..'9') => digits }

          ranges.each_with_object({}) { |(range, start), letters|
            next if start.nil?
            range.each_with_index { |char, i| letters[char] = (start + i).chr(Encoding::UTF_8) }
          }.merge(Hash[*exceptions.split]).freeze
        end

        # Bold Latin letters and digits, plus bold Greek letters
        # from the code points of 'Α' and 'α'.
        BOLD = alphabet(0x1D400, 0x1D41A, 0x1D7CE).merge(
          { 0x0391..0x03A9 => 0x1D6A8, 0x03B1..0x03C9 => 0x1D6C2 }.each_with_object({}) { |(range, start), letters|
            range.each { |code| letters[code.chr(Encoding::UTF_8)] = (start + code - range.first).chr(Encoding::UTF_8) }
          }
        ).freeze

        ALPHABETS = {
          'mathbb' => alphabet(0x1D538, 0x1D552, 0x1D7D8, 'C ℂ H ℍ N ℕ P ℙ Q ℚ R ℝ Z ℤ'),
          'mathcal' => alphabet(0x1D49C, 0x1D4B6, nil,
            'B ℬ E ℰ F ℱ H ℋ I ℐ L ℒ M ℳ R ℛ e ℯ g ℊ o ℴ'),
          'mathfrak' => alphabet(0x1D504, 0x1D51E, nil, 'C ℭ H ℌ I ℑ R ℜ Z ℨ'),
          'mathbf' => BOLD,
          'boldsymbol' => BOLD,
          'bm' => BOLD,
          'mathsf' => alphabet(0x1D5A0, 0x1D5BA, 0x1D7E2),
          'mathtt' => alphabet(0x1D670, 0x1D68A, 0x1D7F6)
        }.freeze

        # Old-style switches apply to the rest of the group;
        # nil means plain letters.
        SWITCHES = {
          'rm' => nil, 'it' => nil, 'mit' => nil,
          'bf' => BOLD,
          'cal' => ALPHABETS['mathcal'],
          'sf' => ALPHABETS['mathsf'],
          'tt' => ALPHABETS['mathtt']
        }.freeze

        PLAIN = %w{mathrm mathit mathnormal mathup operatorname}.freeze

        # Commands whose argument is text, decoded as such.
        TEXT = %w{
          text textrm textup textnormal textit textsl emph mbox hbox
        }.freeze

        def self.convert(body)
          new(body).convert
        rescue Unsupported
          nil
        end

        def initialize(body)
          @scanner = StringScanner.new(body)
        end

        def convert
          result = sequence
          raise Unsupported unless @scanner.eos?
          result.gsub(/\s+/, ' ').gsub(SPACING, '\1').strip
        end

        private

        # Converts everything up to the end or a closing brace.
        def sequence
          result = +''
          result << atom until @scanner.eos? || @scanner.check(/\}/)
          result
        end

        def atom
          if @scanner.scan(/\\([a-zA-Z]+)/)
            command(@scanner[1])
          elsif @scanner.scan(/\\(.)/m)
            CONTROL_SYMBOLS.fetch(@scanner[1]) { raise Unsupported }
          elsif @scanner.scan(/\{/)
            group
          elsif @scanner.scan(/\^/)
            script(SUPERSCRIPTS)
          elsif @scanner.scan(/_/)
            script(SUBSCRIPTS)
          elsif @scanner.scan(/\s+/)
            ' '
          elsif @scanner.scan(/'+/)
            PRIMES.fetch(@scanner.matched.length) { raise Unsupported }
          else
            character(@scanner.getch)
          end
        end

        def group
          result = sequence
          raise Unsupported unless @scanner.scan(/\}/)
          result
        end

        # Returns the raw contents of a braced group.
        def text_group
          @scanner.skip(/\s+/)
          raise Unsupported unless @scanner.scan(/\{/)

          depth = 1
          text = +''

          loop do
            raise Unsupported if @scanner.eos?
            token = @scanner.scan(/\\.|[^\\{}]+/m) || @scanner.getch
            case token
            when '{' then depth += 1
            when '}' then depth -= 1
            end
            break if depth.zero?
            text << token
          end

          text
        end

        # Converts a braced group or a single token.
        def argument
          @scanner.skip(/\s+/)
          raise Unsupported if @scanner.eos? || @scanner.check(/\}/)
          @scanner.scan(/\{/) ? group : atom
        end

        # Every character of the script must have a Unicode equivalent.
        # Spaces are insignificant inside scripts.
        def script(table)
          argument.gsub(/\s+/, '').each_char.map { |char| table.fetch(char) { raise Unsupported } }.join
        end

        def command(name)
          if (symbol = SYMBOLS[name] || FUNCTIONS[name])
            symbol
          elsif (letters = ALPHABETS[name])
            font(letters, argument)
          elsif SWITCHES.key?(name)
            switch(SWITCHES[name])
          elsif PLAIN.include?(name)
            argument
          elsif TEXT.include?(name)
            LaTeX.decode(text_group, math: false)
          elsif STYLES.include?(name)
            ''
          elsif name == 'sp'
            script(SUPERSCRIPTS)
          elsif name == 'sb'
            script(SUBSCRIPTS)
          elsif (space = SPACES[name])
            space
          elsif FRACTIONS.include?(name)
            fraction
          elsif name == 'sqrt'
            root
          elsif DELIMITER_SIZES.include?(name)
            delimiter
          elsif (mark = ACCENTS[name])
            accent(mark)
          elsif (mark = LINES[name])
            line(mark)
          else
            raise Unsupported
          end
        end

        def fraction
          numerator, denominator = argument, argument

          VULGAR_FRACTIONS.fetch("#{numerator}/#{denominator}") {
            [numerator, denominator].map { |part|
              part.match?(COMPOUND) ? "(#{part})" : part
            }.join('/')
          }
        end

        def root
          index = @scanner[1] if @scanner.scan(/\s*\[([^\]]*)\]/)
          sign = ROOTS.fetch(index) { "#{root_index(index)}√" }
          radicand = argument

          # Sub- and superscripts do not count towards needing parentheses.
          base = radicand.delete(SCRIPTS)
          if base.length > 1 && !base.match?(/\A\d+\z/)
            "#{sign}(#{radicand})"
          else
            "#{sign}#{radicand}"
          end
        end

        def root_index(index)
          chars = (self.class.convert(index) || raise(Unsupported)).chars
          raise Unsupported if chars.empty?
          chars.map { |char| SUPERSCRIPTS.fetch(char) { raise Unsupported } }.join
        end

        def accent(mark)
          base = argument
          raise Unsupported unless base.grapheme_clusters.length == 1
          base + mark
        end

        def line(mark)
          symbols = argument.grapheme_clusters
          raise Unsupported if symbols.empty?
          symbols.map { |symbol| symbol.match?(/\s/) ? symbol : symbol + mark }.join
        end

        # Sizing commands are dropped; '.' is the empty delimiter.
        def delimiter
          @scanner.skip(/\s+/)
          @scanner.scan(/\./) ? '' : argument
        end

        # Every character must exist in the font's alphabet.
        # Letters missing from the font are unsupported; everything else
        # (digits, punctuation, sub- and superscripts) passes through.
        def font(letters, string)
          chars = string.chars
          raise Unsupported if chars.empty?

          chars.map { |char|
            letters.fetch(char) {
              raise Unsupported if char.match?(/[\p{L}&&\P{Lm}]/)
              char
            }
          }.join
        end

        def switch(letters)
          @scanner.skip(/\s+/)
          rest = sequence
          letters.nil? ? rest : font(letters, rest.strip)
        end

        def character(char)
          case char
          when '-' then '−'
          when '&', '#', '%' then raise Unsupported
          else char
          end
        end
      end
    end

  end
end
