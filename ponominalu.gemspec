# encoding: utf-8
$: << File.expand_path('../lib', __FILE__)
require 'ponominalu/version'

Gem::Specification.new do |s|
  s.name        = 'ponominalu'
  s.version     = Ponominalu::VERSION
  s.summary     = "Ponominalu gem"
  s.description = "Ponominalu API Ruby wrapper"
  s.authors     = ["Dmitry Kovalevsky"]
  s.email       = 'crossonrails@gmail.com'
  s.files       = ["lib/ponominalu.rb"]
  s.homepage    = 'https://github.com/crossaidi/ponominalu'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 1.9.2'

  s.add_runtime_dependency 'faraday',                     '~> 0.8'
  s.add_runtime_dependency 'faraday_middleware',          '~> 0.8'
  s.add_runtime_dependency 'hashie',                      '~> 2.0'
  s.add_runtime_dependency 'oj',                          '~> 2.8'

  s.add_development_dependency 'bundler',                 '~> 1.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
end