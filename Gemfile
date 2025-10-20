source "https://rubygems.org"

gem "rails", "~> 8.0.3"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"

gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false

gem "kamal", require: false

gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

gem "rspec-rails", "~> 8.0", groups: [ :development, :test ]
gem "factory_bot_rails", "~> 6.5", groups: [ :development, :test ]

gem "devise", "~> 4.9"

gem "bootstrap", "~> 5.3"

gem "dartsass-rails", "~> 0.5.1"

gem "will_paginate", "~> 4.0"

gem "image_processing", "~> 1.14"

# https://github.com/rails/rails/issues/54374
gem "aws-sdk-s3", "1.170", require: false
gem "aws-sdk-core", "3.211"
gem "sidekiq", "~> 8.0"

gem "csv", "~> 3.3"
