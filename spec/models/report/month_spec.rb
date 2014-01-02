require 'spec_helper'

describe Report::Month, :clean_db do
  let(:year)  { 2013 }
  let(:month) { 10 }

  subject(:report) { described_class.new(year, month) }

  let!(:category_fixed) {
    create(:category, name: 'fixed', budget: 1000, fixed: true)
  }
  let!(:sub_category_fixed) {
    create(:sub_category, name: 'fix', category: category_fixed)
  }

  let!(:category_variable) {
    create(:category, name: 'variable', budget: 1000, fixed: false)
  }
  let!(:sub_category_variable) {
    create(:sub_category, name: 'fix', category: category_fixed)
  }

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

  describe "#budget" do
    subject { report.budget }

    it "returns total budget from categories" do
      expect(subject).to eq 2000
    end

    context "when some categories' budget has adjusted" do
    end
  end

  describe "#expenses" do
    subject { report.expenses }

    it "returns all expenses in the month" do
      expect(subject).to eq Expense.where(paid_at: (Time.new(2013,10,1, 0,0,0) ... Time.new(2013,11,1, 0,0,0)))
    end

    context "when month starts on not 1st day" do
      before { Option[:month_starts] = 15 }
      after  { Option.delete :month_starts }

      it "returns all expenses in the month properly" do
        expect(subject).to eq Expense.where(paid_at: (Time.new(2013,10,15, 0,0,0) ... Time.new(2013,11,15, 0,0,0)))
      end
    end
  end

  describe "#weeks" do
    subject { report.weeks }

    it "returns weekly reports" do
      expect(subject.map(&:class)).to eq([Report::Week] * 5)
      expect(subject.map(&:fiscal_week)).to eq(report.fiscal_month.weeks)
    end

    context "when month starts on not 1st day" do
      before { Option[:month_starts] = 15 }
      after  { Option.delete :month_starts }

      it "returns weekly reports" do
        expect(subject.map(&:class)).to eq([Report::Week] * 5)
        expect(subject.map(&:fiscal_week)).to eq(report.fiscal_month.weeks)
        expect(subject[0].fiscal_week.begin).to eq(Date.new(2013, 10, 15))
      end
    end
  end

  describe "#days" do
    subject { report.days }

    it "returns daily reports" do
      expect(subject.map(&:class)).to eq([Report::Day] * 31)
      expect(subject.map(&:date)).to eq(report.fiscal_month.days)
    end

    context "when month starts on not 1st day" do
      before { Option[:month_starts] = 15 }
      after  { Option.delete :month_starts }

      it "returns daily reports" do
        expect(subject.map(&:class)).to eq([Report::Day] * 31)
        expect(subject.map(&:date)).to eq(report.fiscal_month.days)
        expect(subject.first.date).to eq(Date.new(2013, 10, 15))
      end
    end
  end
end
