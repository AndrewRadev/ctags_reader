Ctags "tags" files provide a treasure trove of information on the locations of symbols in a project. Since ruby is such a strongly opinionated language, we can also make some educated guesses in order to get even more useful information out of it.

For now, the project only reads the tags and provides a very simple interface to them, but in the future, more stuff may be added.

## Usage

``` ruby
require 'ctags_reader'

reader = CtagsReader.read('~/src/rails/tags')

# Look for a direct match
puts reader.find('Rails')

# Get a single tag that starts with the given string
puts reader.find('^Active')

# Get all matching tags
puts reader.find_all('^Active').shuffle.take(5)

# Use Array#bsearch if available
puts reader.fast_find('^Active')

# Use some heuristics for advanced matching
puts reader.find('ActionController::Metal#initialize')
```
