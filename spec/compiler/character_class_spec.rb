require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module CharacterClassSpec
  class Foo < Treetop::Runtime::SyntaxNode
  end

  describe "a character class followed by a node class declaration and a block" do

    testing_expression "[A-Z] <CharacterClassSpec::Foo> { def a_method; end }"

    it "matches single characters within that range, returning instances of the declared node class that respond to the method defined in the inline module" do
      result = parse('A')
      result.should be_an_instance_of(Foo)
      result.should respond_to(:a_method)
      result = parse('N')
      result.should be_an_instance_of(Foo)
      result.should respond_to(:a_method)
      result = parse('Z')
      result.should be_an_instance_of(Foo)
      result.should respond_to(:a_method)
    end

    it "does not match single characters outside of that range" do
      parse('8').should be_nil
      parse('a').should be_nil
    end

    it "matches a single character within that range at index 1" do
      parse(' A', :index => 1).should_not be_nil
    end

    it "fails to match a single character out of that range at index 1" do
      parse(' 1', :index => 1).should be_nil
    end
  end

  describe "A character class containing quotes" do
    testing_expression "[\"']"

    it "matches a quote" do
      parse("'").should_not be_nil
    end

    it "matches a double-quote" do
      parse('"').should_not be_nil
    end
  end

  describe "A character class containing a /" do
    testing_expression "[/]"

    it "matches a /" do
      parse("/").should_not be_nil
    end
  end

  describe "A character class containing a # followed by what looks like a Ruby instance variable" do
    testing_expression '[#@a]'

    it "matches a any character in the class" do
      parse("a").should_not be_nil
      parse("@").should_not be_nil
      parse("#").should_not be_nil
    end
  end

  describe "A character class containing a # followed by what looks like a Ruby global variable" do
    testing_expression '[#$%]'

    it "matches a any character in the class" do
      parse("#").should_not be_nil
      parse("$").should_not be_nil
      parse("%").should_not be_nil
    end
  end
end