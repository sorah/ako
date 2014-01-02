require 'spec_helper'

describe Category do
  describe "#expenses" do
    let(:category) { create(:category, :with_sub_categories) }

    let!(:expenses) do
      category.sub_categories.flat_map.with_index do |sc, i|
        i.times.map do
          create(:expense, sub_category_id: sc.id)
        end
      end
    end

    subject { category.expenses }

    it "returns expenses in all sub categories" do
      expect(subject).to eq expenses
    end
  end

  describe ".total_budget" do
    before do
      create(:category, budget: 420)
      create(:category, budget: 1220)
      create(:category, budget: 880)
    end

    subject { described_class.total_budget }

    it "calculates total budget" do
      expect(subject).to eq 2520
    end
  end

  describe "#variable?" do
    subject(:category) { build(:category) }
    subject { category.variable? }

    context "when it is for fixed expenses" do
      before do
        category.fixed = true
      end

      it { should be_false }
    end

    it { should be_true }
  end

  describe "#budget" do
    subject(:category) { build(:category, budget: 100) }
    subject { category.budget }

    it "returns its budget" do
      expect(subject).to eq 100
    end

    # context "when its budget has adjusted for a month" do
    #   context "when month starts on not 1st day" do
    #     before { Option[:month_starts] = 15 }
    #     after  { Option.delete :month_starts }

    #   end
    # end
  end
end
