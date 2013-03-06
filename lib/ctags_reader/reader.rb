require 'active_support/inflector/methods'
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

    def tag_count
      tags.count
    end

    def find(query)
      find_all(query).first
    end

    def find_all(query)
      if query.include?('#')
        class_name, method_name = query.split('#')
        class_filenames = find_all(class_name).map(&:filename).uniq

        find_all(method_name).select do |tag|
          class_filenames.include?(tag.filename)
        end
      elsif query.include?('::')
        filename = class_to_filename(query)
        class_name = query.split('::').last

        direct_find_all(class_name).select do |tag|
          tag.filename =~ /#{filename}$/
        end
      else
        direct_find_all(query)
      end
    end

    def to_s
      "#<CtagsReader::Reader:#{object_id} (#{tag_count} tags)>"
    end

    private

    def class_to_filename(full_class_name)
      ActiveSupport::Inflector.underscore(full_class_name) + '.rb'
    end

    # TODO (2013-02-11) Binary search?
    def direct_find_all(query)
      if query.start_with?('^')
        # consider it a regex
        pattern = Regexp.new(query)
        @tags.select { |name, tags| name =~ pattern }.map(&:last).flatten
      else
        # should be a direct match
        @tags[query] || []
      end
    end

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
