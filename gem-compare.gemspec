$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'rubygems/comparator/version'

Gem::Specification.new do |s|
  s.name     = 'skillnad'
  s.version  = Gem::Comparator::VERSION
  s.platform = Gem::Platform::RUBY
  s.summary     = 'RubyGems plugin for comparing gem versions'
  s.description = <<-EOF
                    skillnad is a RubyGems plugin that helps to compare versions of the given gem.
                    It searches for differences in metadata as well as in files.
                  EOF
  s.homepage = 'http://github.com/dentarg/skillnad'
  s.licenses = ['MIT']
  s.authors  = ['Josef Stribny', 'Patrik Ragnarsson']
  s.email    = ['patrik@starkast.net']
  s.files = Dir['README.md', 'LICENSE', 'Rakefile', 'test/gemfiles/**/*',
                'lib/**/*.rb', 'lib/**/**/*.rb', 'test/**/test*.rb']
  s.required_ruby_version     = '>= 3.0.0'
  s.required_rubygems_version = '>= 3.0.0'
  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'diffy'
  s.add_runtime_dependency 'rainbow'
  s.add_runtime_dependency 'gemnasium-parser'
end
