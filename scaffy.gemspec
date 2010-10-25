# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'scaffy/version'
 
Gem::Specification.new do |s|
  s.name        = "scaffy"
  s.version     = Scaffy::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Alastair Brunton"]
  s.email       = ["info@simplyexcited.co.uk"]
  s.homepage    = "http://github.com/pyrat/scaffy"
  s.summary     = "Opinionated scaffolding generator for rails 3."
  s.description = "Scaffy generates usable scaffolding for a model with tests, layout, namespacing and haml."
 
  s.required_rubygems_version = ">= 1.3.1"
 
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.textile)
  s.require_path = 'lib'
end