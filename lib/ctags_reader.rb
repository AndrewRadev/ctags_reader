require 'ctags_reader/reader'

module CtagsReader
  # Convenience method to parse a tags file into a Reader object.
  #
  def self.read(filename)
    Reader.new(filename)
  end

  # While the reader attempts to parse different formats of ctags, the
  # .generate method generates ruby tags in the most convenient way for the
  # reader.
  #
  def self.generate
    system 'ctags --languages=ruby --excmd=number -R .'
  end
end
