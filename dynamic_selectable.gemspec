# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dynamic_selectable/version'

Gem::Specification.new do |spec|
  spec.name          = 'dynamic_selectable'
  spec.version       = DynamicSelectable::VERSION
  spec.authors       = ['Matt Antonelli']
  spec.email         = ['mattr.antonelli@gmail.com']
  spec.summary       = %q{Allows for easy dynamic population of cascading collection_select fields.}
  spec.description   = 'DynamicSelectable will allow you to easily create collection_select fields
                        with results that dynamically populate a related field.'
  spec.homepage      = 'https://github.com/ATNI/dynamic_selectable'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_runtime_dependency 'coffee-script', '~> 2.3'
  spec.add_runtime_dependency 'rails', '>= 4.1', '< 6.0'
end
