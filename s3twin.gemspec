# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 's3twin'

Gem::Specification.new do |spec|
  spec.name          = 's3twin'
  spec.version       = S3twin::VERSION
  spec.authors       = ['Robert Coleman']
  spec.email         = ['github@robert.net.nz']
  spec.description   = %q{Mirror a S3 Bucket via command line, with support for remote workers (and scheduling).}
  spec.summary       = %q{Mirror a S3 Bucket via command line, with support for remote workers (and scheduling).}
  spec.homepage      = 'https://github.com/rjocoleman/s3twin'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '~> 0.18'
  spec.add_dependency 'dotenv', '~> 0.9'
  spec.add_dependency 'aws-sdk', '~> 1.19'
  spec.add_dependency 'iron_worker_ng', '~> 1.0'
  
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry', '~> 0.9'
  spec.add_development_dependency 'pry-debugger', '~> 0.2'
end
