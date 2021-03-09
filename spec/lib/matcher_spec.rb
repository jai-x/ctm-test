# frozen_string_literal: true

require_relative "../../lib/matcher"
require_relative "../../lib/merchant"
require_relative "../../lib/token"

RSpec.describe Matcher do
  describe "#match" do
    subject { described_class.new(merchants).match(tokens) }

    context "when theres only one possible merchant" do
      let(:merchants) do
        [
          Merchant.new("example", "Example Corp", ["example.com"], ["example"]),
        ]
      end
      let(:tokens) { [Token.new(:literal, "example")] }

      it "returns the merchant" do
        expect(subject).to eq(merchants.first)
      end
    end

    context "when there is more than one merchant" do
      let(:merchants) do
        [
          Merchant.new("example", "Example Corp", ["example.com"], ["example"]),
          Merchant.new("example 2", "Example Corp 2", ["example2.com"], ["example2"]),
        ]
      end

      context "when the tokens match on domain" do
        let(:tokens) { [Token.new(:domain, "example2.com")] }

        it "returns the correct merchant" do
          expect(subject).to eq(merchants.last)
        end
      end

      context "when the tokens match on literals" do
        let(:tokens) { [Token.new(:literal, "example2")] }

        it "returns the correct merchant" do
          expect(subject).to eq(merchants.last)
        end
      end
    end
  end
end
