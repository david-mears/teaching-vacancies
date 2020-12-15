require "rails_helper"

RSpec.describe ABTestSelector do
  subject { described_class.new(tests, user_identifier: user_identifier) }

  let(:tests) do
    {
      my_first_test: { red: 1, blue: 1 },
      another_test: { pink: 1, yellow: 1, beige: 8 },
    }
  end

  let(:user_identifier) { 1000 }

  describe "#selected_variants" do
    it "determines variants based on IP address" do
      expect(subject.selected_variants).to eq(my_first_test: :red, another_test: :pink)
    end
  end

  describe "#variant_for" do
    it "returns the variant for the given test" do
      expect(subject.variant_for(:another_test)).to eq(:pink)
    end

    it "raises when there is no such test" do
      expect { subject.variant_for(:not_found) }.to raise_error(ArgumentError, /no such test/i)
    end
  end

  describe "#variant?" do
    it "returns whether the variant for the given test matches the given variant" do
      expect(subject.variant?(:another_test, :pink)).to be(true)
      expect(subject.variant?(:another_test, :yellow)).to be(false)
      expect(subject.variant?(:another_test, :taupe)).to be(false)
    end

    it "raises when there is no such test" do
      expect { subject.variant?(:not_found, :grey) }.to raise_error(ArgumentError, /no such test/i)
    end
  end
end
