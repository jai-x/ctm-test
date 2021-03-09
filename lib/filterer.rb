# frozen_string_literal: true

require_relative "token"

# Helper class to filter out sequences of unwanted tokens
class Filterer
  # array of sequence of tokens to reject
  def initialize(reject_sequences = [])
    @reject_sequences = reject_sequences
  end

  def filter(tokens = [])
    @reject_sequences.each do |seq|
      next unless seq.length.positive?

      next unless ordered_subset?(tokens, seq)

      idx = tokens.index(seq.first)

      tokens.slice!(idx, seq.length)
    end

    tokens
  end

  private

  def ordered_subset?(superset, subset)
    start_idx = superset.index(subset.first)

    return false unless start_idx

    subset.map.with_index do |sub, idx|
      sub == superset[start_idx + idx]
    end.all?
  end
end
