# ctm-test

## technology

* Ruby v3.0.0
* RSpec (Testing suite)
* Rubocop (Linting)

## install

Ensure `ruby v3.0.0` and `gem bundler` are installed on your system.

Install dependant gems:

```shell
$ bundle install
```
## usage

Input file format is expected as one transaction per line.

```shell
$ bundle exec ruby app.rb <transactions.txt>
```
## testing

Invoke test suite with `rspec`

```shell
$ bundle exec rspec
```
## notes

This seems like a weird problem where the bulk of the work is trying to mangle
strings with some heuristic to more easily parse and sort.

Ideally you would parse and have a description line in an intermediate format to
check against stored indicators for each merchant.

You would also want to avoid having to linearly check against each stored
merchant, so having some sort of primary key value from a description would be
required to pull possible merchant matches.

My approach is to coerce each line such that there is primary key to pluck from
indexed stored existing merchants. Since primary keys can be multiple words,
each transactions can have several primary keys which all attempt to match
against the stored merchants. In the case of multiple primary keys matching for
multiple merchants, a simple confidence value is calculated by the amount of
domain name and literal matches.

From inspect it seem the merchant name always appears close to the front of the
transaction statement which can be used as the key.

## approach

* Split line into words
* Parse words into tokens (domain and literal)
* Filter out useless sequences of token (e.g. direct debit)
* Enumerate possible keys for the transaction (first token + permutations of the
  remaining tokens concatenated in sequence)
* Attempt to find merchant matches from the stored merchants using the keys
  * If one merchant matched, stop
  * If more than one merchant matched, pick one with more matches of literal
    and domain tokens
  * If no merchant matched, generate new merchant from tokens, store and stop


## implementation

The merchant data is stored as an in memory hashmap. This allows for quick
access by using the hash key value. If using an actual database, you can treat 
the `Merchant` struct fields as columns and having an index on the `key` column.

This is mainly coded acting as general classifier of the transaction lines
rather than acting as a Transaction <=> Merchant data store.

In cases of miss-categorised transactions, it is intended that the
configuration information in the `Data` module can be manually adjusted and the
process re-run.

At the moment, any newly created `Unknown` merchants are only stored in the
runtime hashmap and not preserved between runs. This could be implemented in the
future by loading and storing the merchant data in an interchange format (e.g.
JSON/YAML).

All the service classes have behaviour driven unit test.

* `Data` module
  Contains configuration and default stored merchants.

* `Splitter` class
  Utility class to split the original string into words.
  The delimiters for words are specified in the class constructor.

* `Tokenizer` class
  Utility class to parse words into tokens.
  Tokens are classified as either a domain or a literal by a simple regex.
  Domain tokens are parsed into a HTTP URI and have the value of it's fully
  qualified domain name.
  Literal tokens are cleaned to remove special characters and made lowercase.

* `Filterer` class
  Utility class to filter ordered sequences of tokens.
  The token sequences are specified in the class constructor.

* `Matcher` class
  Utility to pick the most confident merchant from the given merchant matches
  and the transaction tokens.
