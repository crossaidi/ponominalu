lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'ponominalu/version'

Gem::Specification.new do |s|
  s.name        = 'ponominalu'
  s.version     = Ponominalu::VERSION
  s.date        = '2014-02-20'
  s.summary     = "Ponominalu gem"
  s.description = "Ponominalu API ruby wrapper and toolkit gem"
  s.authors     = ["Dmitry Kovalevsky"]
  s.email       = 'deecross33@gmail.com'
  s.files       = ["lib/ponominalu.rb"]
  s.homepage    =
    ''
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~>1.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end