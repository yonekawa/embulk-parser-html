Gem::Specification.new do |spec|
  spec.name          = 'embulk-parser-html'
  spec.version       = '0.1.0'
  spec.authors       = ['Kenichi Yonekawa']
  spec.summary       = 'HTML parser plugin for Embulk'
  spec.description   = 'Parses HTML files read by other file input plugins.'
  spec.email         = ['yonekawa@freee.co.jp']
  spec.licenses      = ['MIT']

  spec.files         = `git ls-files`.split('\n') + Dir['classpath/*.jar']
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri', ['~> 1.6']
  spec.add_development_dependency 'embulk', ['>= 0.8.14']
  spec.add_development_dependency 'bundler', ['>= 1.10.6']
  spec.add_development_dependency 'rake', ['>= 10.0']
  spec.add_development_dependency 'rspec', ['~> 3.0']
  spec.add_development_dependency 'pry', ['~> 0.10']
  spec.add_development_dependency 'pry-nav', ['~> 0.2']
end
