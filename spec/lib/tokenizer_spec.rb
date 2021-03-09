# frozen_string_literal: true

require_relative "../../lib/tokenizer"

RSpec.describe Tokenizer do
  describe "#tokens" do
    subject { described_class.new(words).tokens }

    context "when words contain a domain" do
      let(:words) { ["example.com"] }

      it "parses a domain token" do
        expect(subject).to eq([Token.new(:domain, "example.com")])
      end
    end

    context "when words contain a domain with a subdomain" do
      let(:words) { ["subdomain.example.com"] }

      it "parses a domain token including subdomain" do
        expect(subject).to eq([Token.new(:domain, "subdomain.example.com")])
      end
    end

    context "when word contains a malformed domain" do
      let(:words) { ["example....com"] }

      it "parses a literal token" do
        expect(subject).to eq([Token.new(:literal, "example....com")])
      end
    end

    context "when words contain a literal" do
      let(:words) { ["hello"] }

      it "parses a literal token" do
        expect(subject).to eq([Token.new(:literal, "hello")])
      end
    end

    context "when words contain a literal special characters" do
      let(:words) { ["'hello*'*"] }

      it "parses a literal token with special character removed" do
        expect(subject).to eq([Token.new(:literal, "hello")])
      end
    end
  end
end
