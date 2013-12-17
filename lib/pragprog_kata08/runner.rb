require 'pragprog_kata08/trie'

##
# Responsability
#
# Prepare a word list to be read from
# Start finding words made up of concatenated smaller words
# by matching a constraint.
#
module PragprogKata08
  class Runner
    ##
    # Open up singleton class
    #
    class << self

      ENV['path'] ||= "/usr/share/dict/words"

      def run
        list = read_list { |w| trie.insert(w) }
        list.each { |w|
          found = trie.find_concatenated(w.dup)
          print "#{found[0]} + #{found[1]} => #{w}\n" if found.size == 2
        }
      end

      def trie
        @trie ||= Trie.new
      end

      ##
      # Yield words when they match constraint, which by
      # deafault is:
      # greater_than 1 and less or equal than 6
      #
      # It also returns words that where matched.
      #
      def read_list(c={ ">" => 1, "<=" => 6, "wsize" => 6})
        [].tap do |list|
          open_file do |l|
            l.each { |w|
              word = w.strip; wsize = word.length
              wsize <= c["<="] && wsize > c[">"] && yield(word, wsize)
              wsize == c["wsize"] && list << word
            }
          end
        end
      end

      def open_file
        file_manager.open(ENV['path'], "r") { |f| yield(f) }
      end

      def file_manager
        File
      end

    end
  end
end
