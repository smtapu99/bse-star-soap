source 'https://rubygems.org'
ruby "2.2.2"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.2'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'


gem 'bootsnap', '>= 1.1.0', require: false

group :test do
  gem 'capybara', '~> 2.14'
  gem 'faker', '~> 1.7', '>= 1.7.3'
  gem 'launchy', '~> 2.4', '>= 2.4.3'
  gem 'guard-rspec', '~> 4.7', '>= 4.7.3'
  gem 'database_cleaner', '~> 1.6', '>= 1.6.1'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'savon', '~> 2.12.0'
