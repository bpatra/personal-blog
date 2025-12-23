source "https://rubygems.org"

ruby "~> 3.3.0"

# Jekyll 4.3+ for Ruby 3.x compatibility
gem "jekyll", "~> 4.3"

# Required for Ruby 3.x (removed from default gems)
gem "webrick", "~> 1.8"
gem "csv"
gem "base64"
gem "bigdecimal"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :jekyll_plugins do
  gem 'jekyll-paginate'
  gem 'jekyll-seo-tag'
  gem 'jekyll-sitemap'
  gem 'jekyll-archives'
end
