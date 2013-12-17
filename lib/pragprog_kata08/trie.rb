##
#
# == Version 0.0.1
#
# == Author
# Antonio C Nalesso <acnalesso@yahoo.co.uk>
#
# == License
# GNU GPL3
#
# == Description
# This is a Generic implementation of a Radix Tree
# or Patricia Trie.
#
# A word is found based on its length and a binary iteration
# through its chars. Therefore time complexity is O(m).
# Whereas m is the length of the key searched.
#
# See http://en.wikipedia.org/wiki/Radix_tree
#
#
# --------------------------------------------
#
module PragprogKata08
  class Trie < Hash

    Bucket = Array

    ##
    # Inserts a new child in trie
    # Default value is true.
    # trie.insert("rubicon")
    # trie
    # => { "r" => { "ub" => { "ic" => { "on" => [true, {}] } } } }
    #
    def insert(str, value=true)
      root = create_root?(str)
      generate_children(1, root, str, value)
      true
    end

    ##
    # root must be found in order to start searching.
    # When root is found it returns an array containing
    # whatever was found.
    # When root is not found it simply returns an empty array.
    #
    # rkey  means root_key
    #
    def find(key)
      root = root? key.slice(0)
      [].tap { |a| root and probe(0, root, key[1..-1], a) }
      # generate_result([], key) { |rkey, r| r.first.prepend(rkey) }
    end

    ##
    # Returns true if a word is found in trie.
    #
    def find?(word)
      !find(word).empty?
    end

    ##
    # Finds words which are composed of concatenated smaller
    # words.
    #
    def find_concatenated(word)
      [].tap { |a| probe_words(0, word, a) }
    end

    private

    ##
    # Let's say our trie contains +here+ and +by+ in it.
    # Whenever you probe_word it will try to find words
    # based on the word you've given. Therefore if you had
    # given probe_word("herebytest") it would return:
    # ["here", "by"]
    #
    # Whenever a word is found it assigns local var index to 0
    # meaning that it should start looking up all over again and
    # slices off the word, key, found from str. It also tries to
    # find an exact word by creating a new key ( key + str[0] )
    # and tries to find? this new key, this allows us to find
    # words like so:
    #
    # trie.insert("all")
    # trie.insert("al")
    # trie.insert("bums")
    # trie.insert("bum")
    #
    # trie.find_concatenated("allbums")
    # => ["all", "bums"]
    #
    # Rather than ["al", "bum"]
    #
    # So we have a perfect match by trying the next char of
    # given string.
    #
    # Again for performance reasons this snippet of code has
    # to follow this non-object oriented way.
    #
    def probe_words(index, str, r)
      key = str[0..index+1]
      if index < str.size
        if find?(key)
          index = 0; str.slice!(key); next_char = str[0]
          if !next_char.nil? && find?(nkey = key + next_char)
            r << nkey; str.slice!(0)
          else
            r << key
          end
        end
      probe_words(index+1, str, r)
      end
    end

    ##
    # Taps into an object (i.e a String or an Array)
    # and when root is found it starts searching (probe).
    # It then yields root_key and result itself when result
    # is not empty.
    #
    def generate_result(obj, key)
      obj.tap do |a|
        rkey = key[0]
        (rt = root?(rkey)) and probe(0, rt, key[1..-1], a)
        !a.empty? and yield(rkey, a)
      end
    end

    ##
    # It find given words, by probing them, it also waits
    # until index >= str_size so that it knows that this is
    # the last key to be probed and then it assigns result
    # r, result, with whatever value that particular word
    # has stored in trie.
    #
    # Again for performance reasons all the human readable code
    # could not be done. Althought it is not that bad.
    #
    def probe(index, root, str, r)
      str_size = str.length
      if index < str_size
        i = index+2
        key = str[index..index+1]

        root and root = root[1]     || root and found = root[key]
        Bucket === found and i >= str_size  and r[0] = found[0]
        probe(i, found, str, r)
      end
    end

    def root?(root_key)
      self[root_key] || false
    end

    ##
    # Gets first char of a given string
    # "test".slice!(0)
    # => "t"
    # It only creates a root if root is not +nil+.
    def create_root?(str)
      !str.empty? && self[str[0]] ||= {}
    end

    def get_root_key!(str); str.slice!(0); end

    ##
    # Yields when on its last key of a word
    # For example:
    # str = "ere"
    # str[index..index+1]
    # => "er"
    #
    # Now index+2 will be greater than str.length, which is
    # 3 in this case, therefore it knows that this is the last
    # key and the recursion will stop.
    #
    # This is very important to know as it is here that we
    # add given values to buckets (i.e arrays ).
    #
    def last_key?(index, str)
      index+2 >= str.length and yield
    end

    ##
    # trie.insert("her", 15)
    # => { "h" => { "er" => [15, {}] } }
    #
    # trie.insert("here", :there)
    # => { "h" => { "er" => [15, { "e" => [:there, {}] } ] } }
    #
    # Creates children for trie, it passes each child newly
    # created as the next argument.
    # It iterates through a string getting two of
    # its chars creating children and correcting their values.
    # It also adds value to its buckets, by creating an
    # array whose first element is the value passed and the last
    # element are nested keys (i.e leafs ).
    #
    # str[index..index+1]
    # "hereby"
    # "er", "eb", "y"
    #
    # The second LOC within last_key? block is responsible
    # for correcting values regardless of the order a word
    # was inserted and inserting values only once.
    #
    # For example:
    # trie.insert("her", true)
    # { "h" => { "er" => [true, {}] } }
    #
    # trie.insert("here", true)
    # { "h" => { "er" => [true, { "e" => [true, {}] } ] } }
    #
    # If this line did not exist and you were to insert
    # +here+ before than +her+, it would not add her value
    # to its buckets. The output would be as:
    #
    # { "h" => { "er" => { "e" => [true, {}] } } }
    #
    # The third LOC within last_key? block is responsible for
    # creating a new child if it does not exist yet.
    #
    # Finally assigns root to child, sets to a new hash if not
    # set yet, then it starts all over again by calling
    # insert_in_child
    #
    # NOTE:
    # It is worth noting that for performance reasons I could
    # not make this method more human readable.
    # This is a trivial method therefore it should execute as
    # fast as possible.
    # All of this methods are available though.
    #
    # It would have been like this:
    #
    # generate_children(index, children, str, value)
    #   index_less_than_str?(index, str) do |key|
    #     root = generate_children!(children)
    #
    #     last_key?(index, str) { .. }
    #     child = root[key] || {}
    #     generate_children(index+2, child, str, value)
    #   end
    # end
    #
    def generate_children(index, children, str, value)
      str_size = str.size
      if index < str_size
        key   = str[index..index+1]
        root  = children[1] || children

        # last_key?
        if index+2 >= str_size
          rt = root[key]
          rt  && !rt[0] && root[key] = [value, rt]
          !rt && root[key] ||= [value, {}]
        end

        child = root[key] ||= {}
        generate_children(index+2, child, str, value)
      end
    end

    ##
    # Returns a child, which is a hash, or root itself.
    #
    # Note: I could have written this like so:
    # Array === children ? children[1] : children
    #
    # However this looks much cleaner
    #
    def get_child!(children)
      children[1] || children
    end

    def not_found!(rkey)
      "There's not such root:#{rkey} in trie, please add a word first."
    end

    ##
    # When index is less than str it yields and
    # returns key within block.
    #
    def index_less_than_str?(index, str)
      index < str.length and yield(str[index..index+1])
    end

  end
end
