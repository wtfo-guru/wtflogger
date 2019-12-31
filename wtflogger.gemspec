# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wtflogger/version'

Gem::Specification.new do |spec|
  spec.name          = 'wtflogger'
  spec.version       = Wtflogger::VERSION
  spec.authors       = ['Quien Sabe']
  spec.email         = ['qs5779@mail.com']

  spec.summary       = 'ruby gem to facilitate logging'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/wtfo-guru/wtflogger'
  spec.license       = 'Apache-2.0'

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/CHANGLOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.required_ruby_version = '>= 2.3.3'

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.74'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.35'
  spec.add_runtime_dependency 'logging', '>= 2.2.2'
end
