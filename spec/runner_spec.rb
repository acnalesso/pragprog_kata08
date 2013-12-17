require 'spec_helper'
require 'pragprog_kata08/runner'

ENV['path'] = File.
  expand_path("../support/usr/share/dict/words", __FILE__)

describe PragprogKata08::Runner do
  let!(:runner) { PragprogKata08::Runner }
  let!(:words) { ENV['path'] }

  before { ENV['path'] = words }

  describe ".file_manager" do
    it "must have an object to handle files" do
      runner.file_manager.should respond_to :open
    end
  end

  describe ".open_file" do

    it "must open default file to read its words" do
      fake_file_manager = double
      fake_file_manager.should_receive(:open).
        with(words, "r")

      runner.stub(:file_manager).and_return(fake_file_manager)

      runner.open_file
    end

    it "must yield a block" do
      expect {
        runner.open_file { raise }
      }.to raise_error
    end
  end

  ##
  # See spec/support/usr/share/dict/words
  #
  describe ".read_list" do
    it "must yield words that match constraint" do
      list = []
      runner.read_list { |w| list << w }
      list.should have(11).words
    end

    it "must return words that match word_size" do
      runner.read_list { }.should have(2).words
    end
  end

  describe ".run" do

    it "must find concatenated wods" do
      runner.should_receive(:print).exactly(2).times
      runner.run
    end

  end
end
