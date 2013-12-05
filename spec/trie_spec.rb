require 'spec_helper'
require 'pragprog_kata08/trie'

PragprogKata08::Trie.class_eval do
  public(:insert_in_child, :create_root, :finder)
end

describe PragprogKata08::Trie do
  let(:patricia) { PragprogKata08::Trie.new }

  ##
  # Tests behaviour rather than types
  # For example I could have tested that class PatriciaTrie
  # inherits from Hash. However if one day I need to change
  # that inheritance for something else, this test would break.
  #
  it "should be empty" do
    patricia.should be_empty
  end
  context "#insert" do

    it { should respond_to :insert }

    context "root exists" do
      let!(:root) { (patricia["t"] = {}).object_id }

      it "should not create" do
        patricia.insert("test")
        patricia["t"].object_id.should eq(root)
      end
    end

    context "root does not exist" do

      it "should slice first char of string" do
        fake_str = double
        fake_str.should_receive(:slice!).with(0)
        patricia.create_root(fake_str)
      end

      it "creates root" do
        patricia.insert("album")
        patricia.keys.should include("a")
      end

      it "should not create an empty root" do
        patricia.insert("")
        patricia.keys.should_not include(nil)
      end
    end

    it "should call insert_in_child" do
      patricia.should_receive(:insert_in_child).
        with(0, {}, "aw")
      patricia.insert("raw")
    end

  end

  context "private", "#insert_in_child" do
    it { should respond_to :insert_in_child }

    context "index is less than str length" do
      it "should insert in a child of a given root" do
        fake_root = patricia["r"] = {}
        patricia.insert_in_child(0, fake_root, "uby")
        patricia["r"]["ub"].should have(1).child
      end
    end

    context "index is greater than str length" do
      it "does not do anything" do
        fake_root = patricia["f"] = {}
        patricia.insert_in_child(5, fake_root, "fake")
        patricia["f"].should be_empty
      end
    end
  end

  describe "#find" do
    it { should respond_to :find }

    context "found" do
      it "should find +ruby+" do
        patricia.insert("ruby")
        patricia.find("ruby").should eq(["rub", "y"])
      end

      it "returns part of a found string" do
        patricia.insert("rubicon")
        patricia.find("ruby").should eq(["rub"])
      end

    end

    context "not found" do
      it "returns an empty array" do
        patricia.find("error").should eq([])
      end
    end

  end

end
