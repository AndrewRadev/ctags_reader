require 'ctags_reader/tag'

module CtagsReader
  # A Reader can be initialized either with a file (or any IO stream), or with
  # a filename. In the second case, the filename is opened in read-only mode
  # and parsed for tags.
  #
  # Note that parsing is done immediately upon initialization.
  #
  class Reader
    def initialize(file)
      if file.is_a? String
        @filename = File.expand_path(file)
      else
        @file = file
      end

      @tags = {}
      parse
    end

    def file(&block)
      if @file
        yield @file
      else
        File.open(@filename, 'r') do |file|
          yield file
        end
      end
    end

    def names
      @tags.keys
    end

    def tags
      @tags.values.flatten
    end

    def find(query)
      find_all(query).first
    end

    # TODO (2013-02-11) Binary search?
    def find_all(query)
      if query.start_with?('^')
        # consider it a regex
        pattern = Regexp.new(query)
        @tags.select { |name, tags| name =~ pattern }.map(&:last).flatten
      else
        # should be a direct match
        @tags[query] || []
      end
    end

    private

    def parse
      file do |handle|
        handle.each_line do |line|
          next if line.start_with?('!_TAG_')

          tag = Tag.from_string(line)
          @tags[tag.name] ||= []
          @tags[tag.name] << tag
        end
      end
    end
  end
end
