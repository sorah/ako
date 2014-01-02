require 'spec_helper'

describe Report::Day, :clean_db do
  let(:year)  { 2013 }
  let(:month) { 10 }
  let(:day) { 12 }

  subject(:report) { described_class.new(year, month, day) }

  it "includes Common module" do
    expect(described_class.ancestors).to include(Report::Common)
  end

  describe "#year" do
    subject { report.year }
    it { should eq 2013 }
  end

  describe "#month" do
    subject { report.month }
    it { should eq 10 }
  end

  describe "#day" do
    subject { report.day }
    it { should eq 12 }
  end

  describe "#expenses" do
    subject { report.expenses }

    it "returns all expenses on the day" do
      expect(subject).to eq Expense.on(Date.new(2013,10,12))
    end
  end
end
