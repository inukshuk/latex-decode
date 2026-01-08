#--
# LaTeX::Decode
# Copyright (C) 2011-2013 Sylvester Keil <sylvester.keil.or.at>
# Copyright (C) 2010 François Charette
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++

require 'latex/decode/version'
require 'latex/decode/compatibility'
require 'latex/decode/base'

require 'latex/decode/accents'
require 'latex/decode/diacritics'
require 'latex/decode/maths'
require 'latex/decode/punctuation'
require 'latex/decode/symbols'
require 'latex/decode/greek'

module LaTeX

  @decoders = [
    Decode::Maths,
    Decode::Accents,
    Decode::Diacritics,
    Decode::Punctuation,
    Decode::Symbols,
    Decode::Greek
  ]

  class << self
    attr_reader :decoders

    def decode(string, options = {})
      return string unless string.respond_to?(:to_s)

      string = string.is_a?(String) ? string.dup : string.to_s

      Decode::Base.normalize(string)

      decoders.each do |d|
        d.decode! string unless options[d.id] == false
      end

      Decode::Base.strip_braces(string) unless options[:strip_braces] == false

      LaTeX.normalize_C(string)
    end
  end
end
