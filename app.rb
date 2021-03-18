# frozen_string_literal: true

require_relative "lib/data"
require_relative "lib/filterer"
require_relative "lib/merchant"
require_relative "lib/splitter"
require_relative "lib/tokenizer"
require_relative "lib/matcher"

class App
  def initialize(filename)
    @transactions = File.readlines(filename, chomp: true)
    @merchants = Data::MERCHANTS.dup
  end

  def call
    @transactions.each do |line|
      tokens = tokens(line)

      possible_keys = keys(tokens)

      merchant_matches = possible_keys.map { |k| @merchants[k] }.compact

      found_merchant = Matcher.new(merchant_matches).match(tokens)

      unless found_merchant
        new_merchant = build_merchant(tokens)
        @merchants[new_merchant.key] = new_merchant
        found_merchant = new_merchant
      end

      puts "#{found_merchant.name} => #{line}"
    end
  end

  private

  def build_merchant(tokens)
    Merchant.new(
      tokens.first, # naiively assume the first token can act as a key
      "UNKNOWN #{tokens.first.value.upcase}",
      tokens.filter { |t| t.type == :domain }.map(&:value),
      tokens.filter { |t| t.type == :literal }.map(&:value),
    )
  end

  def tokens(lines)
    words = Splitter.new(Data::DELIMITERS).split(lines)
    tokens = Tokenizer.new(words).tokens
    tokens = Filterer.new(Data::REJECT_SEQUENCE).filter(tokens)
    tokens
  end

  def keys(tokens)
    tokens.map.with_index do |_, i|
      tokens.slice(0, 1 + i).map(&:value).join(" ")
    end
  end
end

if ARGV.empty?
  puts "Usage: ruby app.rb <transactions.txt>"
else
  App.new(ARGV.first).call
end
