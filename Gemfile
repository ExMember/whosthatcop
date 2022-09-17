# frozen_string_literal: true

source 'https://rubygems.org'

gem 'jekyll'

gem 'mini_racer'
gem 'webrick'

group :jekyll_plugins do
  gem 'jekyll-autoprefixer'
  gem 'jekyll-remote-theme'
end

# Windows and JRuby does not include zoneinfo files
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem 'tzinfo'
  gem 'tzinfo-data'
end

# Performance-booster for watching directories on Windows
gem 'wdm', platforms: %i[mingw x64_mingw mswin]
