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
  end
end
