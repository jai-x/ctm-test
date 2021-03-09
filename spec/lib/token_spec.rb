# frozen_string_literal: true

require_relative "../../lib/token"

RSpec.describe Token do
  describe "#==" do
    subject { left == right }

    context "when comparing equality of tokens with the same type and value" do
      let(:left) { Token.new(:literal, "hello") }
      let(:right) { Token.new(:literal, "hello") }

      it { is_expected.to eq(true) }
    end
  end

  describe "#eql?" do
    subject { left.eql?(right) }

    context "when comparing equality of tokens with the same type and value" do
      let(:left) { Token.new(:literal, "hello") }
      let(:right) { Token.new(:literal, "hello") }

      it { is_expected.to eq(true) }
    end
  end
end
