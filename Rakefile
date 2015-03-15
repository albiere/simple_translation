require "bundler/gem_tasks"

require "rake"
require "rake/testtask"

Rake::TestTask.new("test:unit")do |t|
  t.libs << "test"
  t.pattern = "test/unit/*_test.rb" 
end

