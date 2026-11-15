if RUBY_PLATFORM == 'java'
  require 'java'

  # Use the Java native Unicode normalizer
  module LaTeX
    def self.normalize_C(string)
      java.text.Normalizer.normalize(string, java.text.Normalizer::Form::NFC).to_s
    end
  end

else
  module LaTeX
    def self.normalize_C(string)
      string.unicode_normalize(:nfc)
    end
  end
end

module LaTeX
  begin
    require 'ritex'

    def self.ritex
      Ritex::Parser.new(:mathml)
    end

    def self.to_math_ml(string)
      ritex.parse string, :nowrap => true, :display => false
    end

  rescue LoadError
    begin
      require 'math_ml'

      def self.to_math_ml(string)
        MathML::String.mathml_latex_parser.parse(string, false)
      end

    rescue LoadError
      # No MathML conversion

      def self.to_math_ml(string)
        string
      end
    end
  end
end
