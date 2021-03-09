# frozen_string_literal: true

require_relative "../../lib/filterer"
require_relative "../../lib/splitter"
require_relative "../../lib/tokenizer"

RSpec.describe Filterer do
  def make_tokens(str)
    words = Splitter.new([/\s+/]).split(str)
    Tokenizer.new(words).tokens
  end

  describe "#filter" do
    subject { described_class.new(reject_tokens).filter(input_tokens) }

    context "when the input tokens do not contain any reject tokens" do
      let(:reject_tokens) { [make_tokens("")] }
      let(:input_tokens) { make_tokens("some cool tokens") }

      it "returns the same tokens" do
        expect(subject).to match_array(make_tokens("some cool tokens"))
      end
    end

    context "when the inpur tokens contain and ordered subset of the reject tokens" do
      let(:reject_tokens) { [make_tokens("direct debit")] }
      let(:input_tokens) { make_tokens("direct debit some cool tokens") }

      it "returns filtered tokens" do
        expect(subject).to match_array(make_tokens("some cool tokens"))
      end
    end

    context "when the input tokens contain and unordered subset of the direct tokens" do
      let(:reject_tokens) { [make_tokens("direct debit")] }
      let(:input_tokens) { make_tokens("direct some debit cool tokens") }

      it "returns the same tokens" do
        expect(subject).to match_array(make_tokens("direct some debit cool tokens"))
      end
    end
  end
end
