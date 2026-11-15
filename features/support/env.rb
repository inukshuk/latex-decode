begin
  require 'simplecov'
  SimpleCov.start
rescue LoadError
  # ignore
end

require 'timeout'
require 'latex/decode'
