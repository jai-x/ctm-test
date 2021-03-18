# frozen_string_literal: true

require_relative "merchant"

class Matcher
  def initialize(merchant_matches)
    @merchant_matches = merchant_matches
  end

  def match(tokens)
    raise "No Tokens!" if tokens.empty?

    return nil if @merchant_matches.empty?

    return @merchant_matches.first if @merchant_matches.length == 1

    @merchant_matches
      .map { |m| [m, confidence(tokens, m)] }
      .max { |a, b| a[1] <=> b[1] }
      .first
  end

  private

  def confidence(tokens, merchant)
    tokens.map do |t|
      case t.type
      when :domain
        merchant.domains.include?(t.value)
      when :literal
        merchant.literals.include?(t.value)
      end
    end.count(true)
  end
end
