# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-with-extra-fields-parser"
  spec.version       = "0.0.1"
  spec.authors       = ["hiraro"]
  spec.email         = ["traurig.orz@gmail.com"]

  spec.summary       = %q{Fluentd parser plugin}
  spec.description   = %q{Appends extra fields after parse.}
  spec.homepage      = "https://github.com/hiraro/fluentd-plugin-with-extra-fields-parser"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "fluentd", "~> 0.12.0"
  spec.add_runtime_dependency "json", ">= 1.4.3"
end
