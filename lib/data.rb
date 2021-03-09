# frozen_string_literal: true

require_relative "merchant"
require_relative "token"

module Data
  DELIMITERS = [
    /\s+/,       # one or more whitespace
    /-/,         # literal dash (-)
  ].freeze

  REJECT_SEQUENCE = [
    [Token.new(:literal, "direct"), Token.new(:literal, "debit")],
    [Token.new(:literal, "subscription")],
    [Token.new(:literal, "payment"), Token.new(:literal, "to")],
  ].freeze

  MERCHANTS = {
    "sainsburys" => Merchant.new(
      "sainsburys",
      "Sainburys",
      %w[sainsburys.co.uk],
      %w[sainsburys sprmrkts],
    ),
    "uber" => Merchant.new(
      "uber",
      "Uber",
      %w[uber.com help.uber.com],
      %w[uber],
    ),
    "uber eats" => Merchant.new(
      "uber eats",
      "Uber Eats",
      %w[uber.com help.uber.com],
      %w[uber eats],
    ),
    "netflix.com" => Merchant.new(
      "netflix.com",
      "Netflix",
      %w[netflix.com],
      %w[netflix],
    ),
    "amazon" => Merchant.new(
      "amazon",
      "Amazon",
      %w[amazon.com amazon.co.uk],
      %w[amazon],
    ),
    "amazon prime" => Merchant.new(
      "amazon prime",
      "Amazon Prime",
      %w[amazon.com amazon.co.uk amzn.co.uk],
      %w[amazon prime],
    ),
    "google" => Merchant.new(
      "google",
      "Google",
      %w[google.com google.co.uk g.co],
      %w[google],
    ),
    "dvla" => Merchant.new(
      "dvla",
      "DVLA",
      %w[gov.uk],
      %w[dvla vehicle],
    ),
    "sky" => Merchant.new(
      "sky",
      "Sky",
      %w[sky.com skygroup.sky bskyb.com],
      %w[sky],
    ),
    "sky digital" => Merchant.new(
      "sky digital",
      "Sky Digital",
      %w[sky.com skygroup.sky bskyb.com],
      %w[sky digital],
    ),
  }.freeze
end
