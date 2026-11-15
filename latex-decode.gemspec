require_relative 'lib/latex/decode/version'

Gem::Specification.new do |s|
  s.name = 'latex-decode'
  s.version = LaTeX::Decode::VERSION.dup
  s.homepage = 'https://github.com/inukshuk/latex-decode'
  s.email = ['sylvester@keil.or.at']
  s.authors = ['Sylvester Keil']
  s.license = 'GPL-3.0-or-later'

  s.summary = 'Decodes LaTeX to Unicode.'
  s.description = 'Decodes strings formatted in LaTeX to equivalent Unicode strings.'

  s.metadata = {
    'source_code_uri' => 'https://github.com/inukshuk/latex-decode',
    'bug_tracker_uri' => 'https://github.com/inukshuk/latex-decode/issues',
    'changelog_uri' => 'https://github.com/inukshuk/latex-decode/blob/main/CHANGELOG.md',
    'rubygems_mfa_required' => 'true'
  }

  s.required_ruby_version = '>= 3.2'

  s.rdoc_options = %w{
    --line-numbers
    --title LaTeX::Decode
    --main README.md
  }
  s.extra_rdoc_files = %w{README.md LICENSE}

  s.files = Dir[
    'lib/**/*.rb',
    'LICENSE',
    'README.md'
  ]
end
