# coding: utf-8

require 'latex/decode/version'

module LaTeX
  class << self
    def decode (string)
      string.gsub!(pattern) { |k| substitutions[k] }
      string.gsub(/{(\S)}/, '\\1')
    end

    def pattern
      @pattern ||= Regexp.union substitutions.keys
    end

    def substitutions
      {
        '\\"a' => 'ä',
        '\\"A' => 'Ä',
        '\\"o' => 'ö',
        '\\"O' => 'Ö',
        '\\"u' => 'ü',
        '\\"U' => 'Ü',
        '--'   => '–',
        ' - '  => ' – ',
        '\\&'  => '&',
      }
    end
  end
end