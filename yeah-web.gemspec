# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'yeah-web/version'

Gem::Specification.new do |s|
  s.name = 'yeah-web'
  s.version = Yeah::Web::VERSION
  s.summary = "Web runner for Yeah the Ruby video game framework"

  s.author = "Artur M. Ostręga"
  s.email = 'artur.mariusz.ostrega@gmail.com'

  s.files = Dir.glob('{lib,opal}/**/*') + %w(LICENSE.txt README.md)

  s.homepage = 'https://github.com/yeahrb/yeah-web'
  s.license = 'MIT'

  s.add_runtime_dependency 'opal', '~> 0.9.0.dev'
end
