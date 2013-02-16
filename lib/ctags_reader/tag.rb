module CtagsReader
  # The Tag is the representation of each tag in the tags file. It can be
  # initialized manually by giving it its four components, but it can also be
  # created from a tab-delimited line from the file.
  #
  class Tag < Struct.new(:name, :filename, :ex_command, :type)
    def self.from_string(string)
      name, filename, ex_command, type = string.split("\t")
      new(name, filename, ex_command, type)
    end

    def line_number
      @line_number ||= calculate_line_number
    end

    private

    def calculate_line_number
      if ex_command.to_i > 0
        return ex_command.to_i
      end

      if not File.readable?(filename)
        return 1
      end

      # remove wrapping / and /;"
      pattern = ex_command.gsub(/^\//, '').gsub(/\/(;")?$/, '')
      regex   = Regexp.new(pattern)

      # try to find line number from file
      File.open(filename, 'r') do |file|
        index = 1
        file.each_line do |line|
          return index if line =~ regex
          index += 1
        end
      end

      # pattern wasn't found, fall back to line 1
      return 1
    end
  end
end
