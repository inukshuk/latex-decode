# frozen_string_literal: true

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
