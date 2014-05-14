require 'rake'
require 'bundler/gem_tasks'

require 'rspec/core'
require 'rspec/core/rake_task'

desc 'Turn on the console with preloaded ponominalu'
task :debug do
  sh 'pry -I ./lib -r ./lib/ponominalu'
end

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec