# PragprogKata08

----------------

See these for more info.
http://codekata.pragprog.com/2007/01/kata_eight_conf.html
http://en.wikipedia.org/wiki/Radix_tree

## Installation

Add this line to your application's Gemfile:

    gem 'pragprog_kata08'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pragprog_kata08

## Usage

Find
```
trie = PragprogKata08::Trie.new
trie.insert("ruby", true)
trie.find("ruby")
#=> [true]

trie.insert("rubicon")
trie.find("rub")
#=> []
```

Find Concatenated
```
trie = PragprogKata08::Trie.new
trie.insert("jig")
trie.insert("saw")
trie.find_concatenated("jigsaw")
#=> ["jig", "saw"]
```


## Rake

If you're on a Unix-like platform there might exist a word list in
usr/share/dict/words, if you run rake without explicitly passing a list
of your own this list will be used.

```
rake run
or
rake
```

What if you want to use a list of your own?
```
rake run path="path_to_my_list"
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
