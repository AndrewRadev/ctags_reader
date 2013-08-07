$: << File.expand_path('../../lib', __FILE__)

require 'benchmark'
require 'ctags_reader'

# Replace with a big tags file
filename = '~/src/rails/tags'

reader = CtagsReader.read(filename)

Benchmark.bm do |bm|
  bm.report('     find') do
    100.times { reader.find('^Rails') }
  end

  bm.report('fast_find') do
    100.times { reader.fast_find('^Rails') }
  end
end
