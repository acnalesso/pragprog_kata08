$:.unshift File.expand_path('../../', __FILE__)

require 'benchmark'
require 'lib/pragprog_kata08'
require 'bmark/rtrie'
require 'bmark/trie'

def read_list(path="/usr/share/dict/words", &block)
  File.open(path, "r") do |lines|
    lines.each { |w| word = w.strip; wsize = word.size; yield(word, wsize) }
  end
end

@list = []
GC.disable
Benchmark.bm do |b|
  print "Mine\n"
  b.report("insert - all words\n") do
    @mtrie = PragprogKata08::Trie.new
    read_list { |w| @mtrie.insert(w) }
  end

  b.report("find - all words\n") do
    read_list { |w| @mtrie.find(w) }
  end

  b.report("find - 6 letter word\n") do
    read_list { |w, ws| ws == 6 and @mtrie.find(w) }
  end

  print "\n\n--------------------------------------------------------------------------------\n"

  # https://github.com/dustin/ruby-trie
  print "\n\nRuby-Trie\n"
  b.report("insert - all words\n") do |b|
    @rtrie = RTrie.new
    read_list { |w, ws| @rtrie.insert(w, true) }
  end

  b.report("find - all words\n") do
    read_list { |w, ws| @rtrie.find(w) }
  end

  b.report("find - 6 letter word\n") do
    read_list { |w, ws| ws == 6 and @rtrie.find(w) }
  end

  print "\n\n--------------------------------------------------------------------------------\n"

  # http://www.igvita.com/2009/03/26/ruby-algorithms-sorting-trie-heaps/
  print "\n\nOther\n"
  b.report("insert - all words\n") do
    @otrie = Trie.new
    read_list { |w|  @otrie.push(w, true) }
  end


  b.report("find - all words\n") do
    read_list { |w| @otrie.get(w) }
  end

  b.report("find - 6 letter word\n") do
    read_list { |w, ws| ws == 6 and @otrie.get(w) }
  end

end
GC.enable
