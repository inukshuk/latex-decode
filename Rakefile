require 'rake'

task :convert => [] do
  `git ls-files -- lib/latex/decode/*.rb`.split("\n").each do |file|
    content = File.read(file).gsub(/\\u([\da-f]{4})/i) { |m| [$1.to_i(16)].pack('U') }
    File.open(file, "w+") do |f|
      f.write(content)
    end
  end
end
