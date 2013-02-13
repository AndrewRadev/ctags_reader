require File.expand_path('../lib/ctags_reader/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'ctags_reader'
  s.version     = CtagsReader::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Andrew Radev']
  s.email       = ['andrey.radev@gmail.com']
  s.homepage    = 'http://github.com/AndrewRadev/ctags_reader'
  s.summary     = 'Read a ctags "tags" file and provide an interface to its information'
  s.description = <<-D
    Ctags "tags" files provide a treasure trove of information on the locations
    of symbols in a project. Since ruby is such a strongly opinionated
    language, we can also make some educated guesses in order to get even more
    useful information out of it.
  D

  s.add_development_dependency 'rspec', '>= 2.0.0'
  s.add_development_dependency 'rake'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'ctags_reader'

  s.files        = Dir['{lib}/**/*.rb', 'bin/*', 'LICENSE', '*.md']
  s.require_path = 'lib'
  s.executables  = ['ctags_reader']
end
