require "rails_helper"

RSpec.describe Search::SimilarJobs do
  subject { described_class.new(vacancy) }

  let(:school) { create(:school) }
  let(:vacancy) { create(:vacancy, :at_one_school, organisation_vacancies_attributes: [{ organisation: school }]) }

  it "calls Search::CriteriaDeviser" do
    expect(Search::CriteriaDeviser).to receive(:new).with(vacancy).and_call_original
    subject
  end

  it "calls Search::SearchBuilder" do
    expect(Search::SearchBuilder).to receive(:new).and_call_original
    subject
  end
end
