require 'spec_helper'

module CtagsReader
  describe Tag do
    describe "#line_number" do
      it "can be retrieved if the ex_command is a line number" do
        tag = Tag.new('foo', 'foo.rb', '3;"', 'm')
        tag.line_number.should eq 3
      end

      it "finds the line number from the file if the ex_command is a pattern" do
        File.open('foo.rb', 'w') do |file|
          file.write([
            '# comment',
            'def foo',
            'end',
          ].join("\n"))
        end
        tag = Tag.new('foo', 'foo.rb', '/^def foo$/;"', 'm')
        tag.line_number.should eq 2
      end

      it "returns 1 if the ex_command is a pattern and the relevant file doesn't exist" do
        tag = Tag.new('foo', 'foo.rb', '/^def foo$/;"', 'm')
        tag.line_number.should eq 1
      end
    end
  end
end
