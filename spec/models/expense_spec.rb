require 'spec_helper'

describe Expense do
  describe ".in_a_month_of(day)" do
    subject { Expense.in_a_month_of(arg) }

    let(:month) { double("fiscal_month") }

    before do
      expect(FiscalDate).to receive(:locate_month) \
                        .with(arg).and_return(month)
    end

    context "with Time" do
      let(:arg) { Time.now }

      it "calls .in with current month" do
        Expense.should_receive(:in).with(month).and_return [1,2,3]
        expect(subject).to eq [1,2,3]
      end
    end

    context "with Date" do
      let(:arg) { Date.today }

      it "calls .in with current month" do
        Expense.should_receive(:in).with(month).and_return [1,2,3]
        expect(subject).to eq [1,2,3]
      end
    end
  end

  describe ".in_this_month" do
    subject { Expense.in_this_month }

    let(:month) { double("this_month") }
    before do
      allow(FiscalDate).to receive(:current_month) \
                       .and_return(month)
    end

    it "calls .in with current month" do
      Expense.should_receive(:in).with(month).and_return [1,2,3]
      expect(subject).to eq [1,2,3]
    end
  end

  describe ".in_a_week_of(day)" do
    subject { Expense.in_a_week_of(arg) }

    let(:week) { double("fiscal_week") }
    before do
      expect(FiscalDate).to receive(:locate_week) \
                        .with(arg) \
                        .and_return(week)
    end

    context "with Time" do
      let(:arg) { Time.now }

      it "calls .in with current week" do
        Expense.should_receive(:in).with(week).and_return [1,2,3]
        expect(subject).to eq [1,2,3]
      end
    end

    context "with Date" do
      let(:arg) { Date.today }

      it "calls .in with current week" do
        Expense.should_receive(:in).with(week).and_return [1,2,3]
        expect(subject).to eq [1,2,3]
      end
    end
  end

  describe ".in_this_week" do
    subject { Expense.in_this_week }

    let(:date) { Date.today }
    let(:week) { double("week") }

    before do
      allow(FiscalDate).to receive(:current_week) \
                       .and_return(week)
    end

    it "calls .in with current month" do
      Expense.should_receive(:in).with(week).and_return [1,2,3]
      expect(subject).to eq [1,2,3]
    end
  end

  describe ".in(fiscal_month_or_week)" do
    subject { Expense.in(arg) }

    let(:arg) { nil }

    context "with range" do
      let(:arg) { (Date.new(2013, 5, 1) .. Date.new(2013, 5, 31)) }

      it { should == Expense.where(paid_at: (Date.new(2013, 5, 1) .. Date.new(2013, 5, 31))) }
    end

    context "with fiscal cal" do
      let(:arg) { double("fiscal", range_in_time: (Date.new(2013, 5, 1) .. Date.new(2013, 5, 31))) }

      it { should == Expense.where(paid_at: (Date.new(2013, 5, 1) .. Date.new(2013, 5, 31))) }
    end
  end

  describe "#category", clean_db: true do
    let(:sub_category) { create(:sub_category) }
    let(:expense_new)  { create(:expense, sub_category: sub_category)  }
    let(:expense) { expense_new }

    subject { expense.category }

    it "returns category via sub_category" do
      expect(expense.category).to eq(sub_category.category)
    end

    context "when coming from .find" do
      let(:expense) { Expense.find(expense_new.id) }

      it "returns category via sub_category" do
        expect(expense.category).to eq(sub_category.category)
      end
    end

    context "when coming from relation" do
      let(:expense) { Expense.where(id: expense_new.id).first }

      it "returns category via sub_category" do
        expect(expense.category).to eq(sub_category.category)
      end
    end

    context "when sub_category has loaded" do
      let(:expense) { Expense.find(expense_new.id) }

      before { expense.sub_category }

      it "returns category via sub_category" do
        expect(expense.category).to eq(sub_category.category)
      end
    end

    context "when sub_category is not given" do
      let(:sub_category) { nil }

      it "returns nil" do
        expect(expense.category).to be_nil
      end
    end

    describe "reloading" do
      let(:another_sub_category) { create(:sub_category, name: '2') }

      it "can be reloaded" do
        expense.category # to load

        Expense.find(expense.id) \
               .update_attributes!(sub_category: another_sub_category)

        expect(expense.reload.category).to eq(another_sub_category.category)
      end
    end

    describe "saving" do
      it "can be saved" do
        expense.category # to load
        expense.comment = "Lunch"
        expect { expense.save! }.to_not raise_error
      end
    end
  end

  it "includes PlaceNameAccessor" do
    expect(described_class.ancestors).to include(PlaceNameAccessor)
  end

  describe "#fixed?", :clean_db do
    subject(:expense) { build(:expense) }
    subject { expense.fixed? }

    context "when it is marked as fixed expense" do
      before do
        expense.fixed = true
      end

      it { should be_true }
    end

    context "when its category is for fixed expenses" do
      let(:sub_category) { create(:sub_category, category: create(:category, fixed: true)) }
      before do
        expense.sub_category = sub_category
      end

      it { should be_true }
    end

    it { should be_false }
  end

  describe "#variable?", :clean_db do
    subject(:expense) { build(:expense) }
    subject { expense.variable? }

    context "when it is marked as fixed expense" do
      before do
        expense.fixed = true
      end

      it { should be_false }
    end

    context "when its category is for fixed expenses" do
      let(:sub_category) { create(:sub_category, category: create(:category, fixed: true)) }
      before do
        expense.sub_category = sub_category
      end

      it { should be_false }
    end

    it { should be_true }
  end

  describe ".fixed", :clean_db do
    subject { Expense.fixed }

    let!(:category_a) { create(:sub_category, category: create(:category, fixed: true)) }
    let!(:expense_a) { create(:expense, fixed: true) }
    let!(:expense_b) { create(:expense, sub_category: category_a) }
    let!(:expense_c) { create(:expense, fixed: false) }

    it "includes fixed expenses" do
      expect(subject).to include expense_a
    end

    it "includes expenses categorized as category for fixed expenses" do
      expect(subject).to include expense_b
    end

    it "doesn't include non fixed expenses" do
      expect(subject).to_not include expense_c
    end
  end

  describe ".variable", :clean_db do
    subject { Expense.variable }

    let!(:category_a) { create(:sub_category, category: create(:category, fixed: true)) }
    let!(:expense_a) { create(:expense, fixed: true) }
    let!(:expense_b) { create(:expense, sub_category: category_a) }
    let!(:expense_c) { create(:expense, fixed: false) }

    it "doesn't include fixed expenses" do
      expect(subject).to_not include expense_a
    end

    it "doesn't include expenses categorized as category for fixed expenses" do
      expect(subject).to_not include expense_b
    end

    it "includes non fixed expenses" do
      expect(subject).to include expense_c
    end
  end
end
