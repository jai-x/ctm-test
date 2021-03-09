# frozen_string_literal: true

require "uri"

require_relative "token"

# Service class clean and parse words into token types
class Tokenizer
  SPECIAL_CHARS = [
    "'",
    "*",
    "!",
  ].freeze

  # URI::regexp is wayyy too permissive on what it accepts as a URI so we use a subset
  DOMAIN_REGEX = %r{^[a-z0-9]+([\-.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?$}

  def initialize(words)
    @words = words
  end

  def tokens
    @words.map do |w|
      if domain?(w)
        Token.new(:domain, domain(w))
      else
        Token.new(:literal, clean(w))
      end
    end
  end

  private

  def domain?(str)
    DOMAIN_REGEX.match?(str)
  end

  def domain(str)
    URI.parse("https://#{str}").host
  end

  def clean(str)
    SPECIAL_CHARS.each { |char| str = str.delete(char) }
    str.downcase
  end
end
