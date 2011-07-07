module LaTeX
  module Decode
    class Decoder
      class << self
        attr_reader :pattern, :map
    
        def decode (string)
          decode!(string.dup) || string
        end
        
        def decode! (string)
          string.gsub!(pattern) { |m| [$2,map[$1]].compact.join }
        end

      end
    end
  end
end