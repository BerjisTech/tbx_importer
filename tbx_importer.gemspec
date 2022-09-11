# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tbx_importer/version'

Gem::Specification.new do |spec|
  spec.name          = "tbx_importer"
  spec.version       = TbxImporter::VERSION
  spec.authors       = ["Kevin S. Dias"]
  spec.email         = ["diasks2@gmail.com"]

  spec.summary       = %q{TBX (TermBase eXchange) file importer}
  spec.description   = %q{Import the content of a TBX (TermBase eXchange) file}
  spec.homepage      = "https://github.com/diasks2/tbx_importer"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "libxml-ruby"
  # spec.add_runtime_dependency "pretty_strings"
  spec.add_runtime_dependency "charlock_holmes"
end
