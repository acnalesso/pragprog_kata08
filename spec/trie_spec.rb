require 'spec_helper'
require 'pragprog_kata08/trie'

PragprogKata08::Trie.class_eval do
  public( :generate_children, :create_root?,
          :probe, :index_less_than_str?)
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

      it "should create root with first char of string" do
        fake_str = double
        fake_str.stub(:empty?).and_return(false)
        fake_str.should_receive(:[]).with(0)
        patricia.create_root?(fake_str)
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

    it "should generate_children" do
      patricia.should_receive(:generate_children).
        with(1, {}, "raw", true)
      patricia.insert("raw")
    end

    it "inserts its values at the end of each word" do
      patricia.insert("her", :beer)
      patricia["h"]["er"].should eq([:beer, {}])
    end

    it "must nest matching keys and keep its values" do
      patricia.insert("her", :her)
      patricia.insert("here", false)
      patricia["h"]["er"].should eq([:her, { "e" => [false, {}] } ])
    end

    it "must insert values regardless of order a word was added" do
      patricia.insert("here", :here)
      patricia.insert("her", :her)
      patricia["h"]["er"].should eq([:her, { "e" => [:here, {}] } ])
    end

    it "must insert values only once" do
      patricia.insert("her", true)
      patricia.insert("her", :wont)
      patricia["h"]["er"].should eq([true, {}])
    end
  end

  context "private", "#generate_children" do
    it { should respond_to :generate_children }

    context "index is less than str length" do
      it "should generate children for a given root" do
        fake_root = patricia["r"] = {}
        patricia.generate_children(0, fake_root, "uby", true)
        patricia["r"]["ub"].should have(1).child
      end
    end

    context "index is greater than str length" do
      it "should not generate children" do
        fake_root = patricia["f"] = {}
        patricia.generate_children(5, fake_root, "fake", true)
        patricia["f"].should be_empty
      end
    end
  end

  describe "#index_less_than_str?" do
    context "less than str" do
      it "yields" do
        patricia.index_less_than_str?(0, "test") {
          true
        }.should be_true
      end
    end

    context "greater than str" do
      it "does not yield" do
        patricia.index_less_than_str?(6, "test") {
          true
        }.should be_false
      end
    end
  end

  describe "#find" do
    it { should respond_to :find }

    context "found" do
      it "should find a given word" do
        patricia.insert("ruby")
        patricia.find("ruby").should be_true
      end

      it "should not find when word is not in trie" do
        patricia.insert("rubicon")
        patricia.find("ruby").should be_empty
      end

      it "a very nested word" do
        patricia.insert("AOL's")
        patricia.insert("AC's")
        patricia.insert("ACTH's")
        patricia.insert("ACT's")
        patricia.insert("ACTH's")
        patricia.insert("ACTH'ss")
        patricia.insert("ACTH'ssac")
        patricia.insert("ACTH'ssaccaac")
        patricia.find("ACTH'ssac").should be_true
      end

    end

    context "not found" do
      it "returns an empty array" do
        patricia.find("error").should eq([])
      end

    end
  end

  describe "#find?" do

    before { patricia.insert("test") }

    context "found" do
      it "returns word found" do
        patricia.find?("test").should be_true
      end
    end

    context "not found" do
      it "must be empty" do
        patricia.find?("patricia").should be_false
      end
    end
  end

  describe "#find_concatenated" do
    it "finds a word composed of two smaller words" do
      patricia.insert("all")
      patricia.insert("allla")
      patricia.insert("al")
      patricia.insert("bums")
      patricia.insert("bu")
      patricia.insert("bum")

      expect(patricia.find_concatenated("allbums")).
      to eq(["all", "bums"])
    end

    it "must find more than 2 concatenated words" do
      patricia.insert("counter")
      patricia.insert("clock")
      patricia.insert("wise")

      expect(patricia.find_concatenated("counterclockwise")).
        to eq(["counter", "clock", "wise"])
    end

  end
end
