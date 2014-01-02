require 'spec_helper'

describe Report::Week, :clean_db do
  let(:year)  { 2013 }
  let(:month) { 10 }
  let(:weekno) { 1 }

  subject(:report) { described_class.new(year, month, weekno) }

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

  describe "#number" do
    subject { report.number }
    it { should eq 2 }
  end

  describe "#fiscal_week" do
    subject { report.fiscal_week }
    it { should eq FiscalDate::Week.in(2013, 10)[1] }
  end

  describe "#expenses" do
    subject { report.expenses }

    it "returns all expenses in the week" do
      expect(subject).to eq Expense.in(FiscalDate::Week.in(2013, 10)[1])
    end

    context "when month/week starts on not 1st day" do
      before { Option[:month_starts] = 15 }
      before { Option[:week_starts] = 2 }
      after  { Option.delete :month_starts }
      after  { Option.delete :week_starts }

      it "returns all expenses in the week properly" do
        expect(subject).to eq Expense.in(FiscalDate::Week.in(2013, 10)[1])
      end
    end
  end

  describe "#days" do
    subject { report.days }

    it "returns daily reports" do
      expect(subject.map(&:class)).to eq([Report::Day] * 7)
      expect(subject.map(&:date)).to eq(report.fiscal_week.days)
    end
  end
end
