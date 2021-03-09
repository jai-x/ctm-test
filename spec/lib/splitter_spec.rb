# frozen_string_literal: true

require_relative "../../lib/splitter"

RSpec.describe Splitter do
  describe "#split" do
    subject { described_class.new(delimiters).split(line) }

    context "when using a whitespace delimiter" do
      let(:delimiters) { [/\s+/] }
      let(:line) { "foo bar baz bat" }

      it "splits the line by whitespace" do
        expect(subject).to eq(%w[foo bar baz bat])
      end
    end

    context "when using a character delimiter" do
      let(:delimiters) { [/-/] }
      let(:line) { "foo-bar-baz-bat" }

      it "splits the line by the character" do
        expect(subject).to eq(%w[foo bar baz bat])
      end
    end

    context "when using mixed whitespace and character delimiters" do
      let(:delimiters) { [/\s+/, /-/] }
      let(:line) { "foo     bar \tbaz - bat" }

      it "splits the line by both delimiters" do
        expect(subject).to eq(%w[foo bar baz bat])
      end
    end
  end
end
