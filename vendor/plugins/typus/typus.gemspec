# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "typus/version"

Gem::Specification.new do |s|
  s.name = "typus"
  s.version = Typus::VERSION
  s.date = Date.today

  s.platform = Gem::Platform::RUBY
  s.authors = ["Francesc Esplugas"]
  s.email = ["core@typuscms.com"]
  s.homepage = "http://core.typuscms.com/"
  s.summary = "Effortless backend interface for Ruby on Rails applications. (Admin scaffold generator)"
  s.description = "Awesone admin scaffold generator for Ruby on Rails applications."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = "typus"

  s.files = Dir.glob("**/*")
  s.require_path = "lib"

  s.add_development_dependency "rails", [">= 3.0.0.beta4"]
  s.add_development_dependency "fastercsv", ["1.5.3"]
  s.add_development_dependency "sqlite3-ruby"
  s.add_development_dependency "mysql"
  s.add_development_dependency "pg"
  s.add_development_dependency "factory_girl", ["1.3.0"]
  s.add_development_dependency "mocha"
  s.add_development_dependency "redgreen"
  s.add_development_dependency "acts_as_tree"
  s.add_development_dependency "acts_as_list"
  s.add_development_dependency "paperclip"

end
