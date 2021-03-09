# frozen_string_literal: true

# Utility class to split a string by predefined delmiters in a consistent way
class Splitter
  def initialize(delimiters)
    @delimiters = delimiters
  end

  def split(line)
    words = [line]

    @delimiters.each do |delim|
      words = words.map { |word| word.split(delim) }.flatten
    end

    words
  end
end
