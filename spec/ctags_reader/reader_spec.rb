require 'spec_helper'
require 'stringio'
require 'ctags_reader/reader'

module CtagsReader
  describe Reader do
    let(:input) do
      StringIO.new([
        'ClassName	lib/class_name.rb	/^class ClassName$/	c',
        'ClassNameTwo	lib/class_name_two.rb	/^class ClassNameTwo$/	c',
        'method_name	lib/class_name.rb	/^  def method_name$/	m',
        'method_name	lib/class_name_two.rb	/^  def method_name$/	m',
      ].join("\n"))
    end
    let(:reader) { Reader.new(input) }

    it "knows all of its tag names" do
      reader.names.should =~ %w(ClassName ClassNameTwo method_name)
    end

    it "knows all of its tags" do
      reader.tags.map(&:name).should =~ %w(ClassName ClassNameTwo method_name method_name)
    end

    it "can find tags as a direct match" do
      reader.find('ClassName').name.should eq 'ClassName'
      reader.find('method_name').name.should eq 'method_name'
    end

    it "can find tags that start with a pattern" do
      reader.find('^method_').name.should eq 'method_name'
      reader.find_all('^ClassName').map(&:name).should =~ %w(ClassName ClassNameTwo)
    end

    it "can find multiple tags with the same name" do
      reader.find_all('method_name').should have(2).items
    end

    it "returns nothing for non-existent tags" do
      reader.find('nonexistent').should be_nil
      reader.find('^nonexistent').should be_nil
      reader.find_all('^nonexistent').should be_empty
    end
  end
end