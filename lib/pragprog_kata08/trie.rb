##
#
# == Version 0.0.1
#
# == Author
# Antonio C Nalesso <acnalesso@yahoo.co.uk>
#
# == Copyleft
# Copyleft 2013 Nalesso Antonio
#
# == License
# GNU GPL3
#
# == Description
# This is a Generic implementation of a Radix Tree
# or Patricia Trie.
#
# It does not provides all the functionalites that a radix tree
# should provide but it works pretty much the same way.
#
# It does not allow any entry of values, a word is found based
# on its length and a binary iteration of its chars.
#
# See http://en.wikipedia.org/wiki/Radix_tree
#
module PragprogKata08
  class Trie < Hash
    ##
    # Inserts a new child in trie
    # trie.insert("rubicon")
    # trie
    # => { "r" => { "ub" => { "ic" => { "on" => {} } } } }
    #
    def insert(str)
      root = create_root(str)
      insert_in_child(0, root, str)
    end

    ##
    # root must be found in order to start searching.
    # When root is found it returns an array containing
    # whatever was found.
    # When root is not found it simply returns an empty array.
    #
    # rkey  means root_key
    # r     means result
    #
    def find(key)
      [].tap do |r|
        rkey  = get_root_key!(key)
        root?(rkey) && start_searching(rkey, key, r)
      end
    end

    private

    ##
    # Returns false when root_key is not found.
    # If root is found it assigns it to the
    # instance var root.
    #
    def root?(root_key)
      @root = self[root_key] || false
    end

    ##
    # It calls finder in order to start searching,
    # whenever finder is done it prepends rkey to
    # the first element in result array.
    #
    def start_searching(rkey, key, r)
      finder(0, @root, key, r)
      r.first.prepend(rkey)
    end

    ##
    # It iterates over children by going through
    # 2 chars from str.
    # Whenever a child is found it pushes key to result.
    #
    # For example:
    # trie.insert("rubicon")
    # trie.find("ruby")
    # => ["rub"]
    #
    def finder(index, root, str, result)
      if index < str.length
        key = str[index..index+1]
        child = root[key]
        result << key if child
        finder(index+2, child, str, result)
      end
    end

    ##
    # Gets first char of a given string
    # "test".slice!(0)
    # => "t"
    # It only creates a root if root is not +nil+.
    def create_root(str)
      root = get_root_key!(str)
      root && self[root] ||= {}
    end

    def get_root_key!(str); str.slice!(0); end

    ##
    # Based on the index size it creates children for root.
    # By passing created child as the next root an so on
    # an so forth.
    # a = { "t" => { } } THE_ROOT
    # insert_in_child(0, a, "est")
    # => { "t" => { "es" => { "t" => {} } } }
    #
    # It gets two chars of str each time it inserts in a child.
    # Given a string "ruby"
    # It would be "ru", "by"
    #
    def insert_in_child(index, root, str)
      if index < str.length
        key = str[index..index+1]
        child = root[key] ||= {}
        insert_in_child(index+2, child, str)
      end
    end
  end
end
