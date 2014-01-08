source 'https://rubygems.org'
gemspec

group :test do
  gem 'rake'
  gem 'rspec', '~> 2.13'
  gem 'cucumber', '~> 1.2'
end

group :debug do
	gem 'debugger', :platforms => [:mri_19, :mri_20, :mri_21]
	gem 'ruby-debug', :platforms => [:mri_18]
  gem 'rubinius-debugger', :require => false, :platforms => :rbx
  gem 'rubinius-compiler', :require => false, :platforms => :rbx
end

gem 'unicode', '~> 0.4', :platforms => [:mri, :rbx, :mswin, :mingw]
gem 'ritex', '~> 1.0.1'
