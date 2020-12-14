require "rails_helper"

RSpec.describe ABTestSelector do
  subject { described_class.new(tests, request: request) }

  let(:tests) do
    {
      my_first_test: %w[red blue],
      another_test: %w[pink yellow beige],
    }
  end

  let(:ip) { "1.2.3.4" }
  let(:request) { double(ActionDispatch::Request, remote_ip: ip) }

  describe "#selected_variants" do
    it "determines variants based on IP address" do
      expect(subject.selected_variants).to eq(my_first_test: :red, another_test: :yellow)
    end
  end
end
