lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sm_808/version"

Gem::Specification.new do |spec|
  spec.name          = "sm_808"
  spec.version       = Sm808::VERSION
  spec.authors       = ["Tony Schneider"]
  spec.email         = ["tonywok@gmail.com"]

  spec.summary       = %q{SM 808 Drum Sequencer}
  spec.description   = %q{Programming exercise - code the sequencer part of a Drum Machine}
  spec.homepage      = "https://github.com/splicers/sm-808"
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables << "sm_808"
  spec.require_paths = ["lib"]

  spec.add_dependency "em-websocket"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-doc"
  spec.add_development_dependency "pry-byebug"
end
