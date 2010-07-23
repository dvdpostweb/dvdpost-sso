require 'rake'

namespace :ci do
  desc 'Prepare for CI'
  task :prepare do
    `bundle install --relock`
    `mv config/database.yml.ci config/database.yml`
    `mv db/test_schema.rb db/schema.rb`
    `rake db:test:load`
  end

  desc 'Prepare for CI and run entire test suite'
  task :build => ['ci:prepare', 'spec']
end
