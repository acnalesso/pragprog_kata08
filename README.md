# PragprogKata08

----------------

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'pragprog_kata08'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pragprog_kata08

## Usage

```
trie = PragprogKata08::Trie.new
trie.insert("ruby")
trie.find("ruby")
#=> ["rub", "y"]

trie.insert("rubicon")
trie.find("rub")
#=> ["rub"]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
