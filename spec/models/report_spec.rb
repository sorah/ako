require 'spec_helper'

describe Report do
  let(:month) { [2013, 9] }
  subject(:report) { described_class.new(*month) }

  describe "#year" do
    subject { report.year }
    it { should eq 2013 }
  end

  describe "#month" do
    subject { report.month }
    it { should eq 9 }
  end

  describe "#budget" do
    subject { report.budget }

    it { should be_a_kind_of(Numeric) }

    it "returns total_budget"

    context "when budget has changed for a month" do
      it "returns total_budget properly"
    end
  end

  describe "#usage" do
    subject { report.usage }

    it { should be_a_kind_of(Numeric) }

    it "returns total_usage"
  end

  describe "#categories" do
    subject { report.categories }

    it { should be_a(Report::CategoryCollection) }

    it "returns with proper month" do
      expect(subject.year ).to eq month[0]
      expect(subject.month).to eq month[1]
    end
  end

  describe "#weeks" do
    subject { report.weeks }

    before do
      FiscalDate::Month.any_instance.stub(weeks: [
        stub(number: 0),
        stub(number: 1),
        stub(number: 2),
        stub(number: 3),
      ])
    end

    it { should be_a(Array) }

    it "returns Week-s with proper month" do
      subject.each_with_index do |w, i|
        expect(subject).to be_a(FiscalDate::Week)
        expect(subject.year  ).to eq month[0]
        expect(subject.month ).to eq month[1]
        expect(subject.number).to eq i
      end
    end
  end
end
