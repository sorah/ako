require 'spec_helper'

describe Payment do
  describe ".in_a_month_of(day)" do
    subject { Payment.in_a_month_of(arg) }

    let(:month) { double("fiscal_month") }

    before do
      expect(FiscalDate).to receive(:locate_month) \
                        .with(arg).and_return(month)
    end

    context "with Time" do
      let(:arg) { Time.now }

      it "calls .in with current month" do
        Payment.should_receive(:in).with(month).and_return [1,2,3]
        expect(subject).to eq [1,2,3]
      end
    end

    context "with Date" do
      let(:arg) { Date.today }

      it "calls .in with current month" do
        Payment.should_receive(:in).with(month).and_return [1,2,3]
        expect(subject).to eq [1,2,3]
      end
    end
  end

  describe ".in_this_month" do
    subject { Payment.in_this_month }

    let(:month) { double("this_month") }
    before do
      allow(FiscalDate).to receive(:current_month) \
                       .and_return(month)
    end

    it "calls .in with current month" do
      Payment.should_receive(:in).with(month).and_return [1,2,3]
      expect(subject).to eq [1,2,3]
    end
  end

  describe ".in_a_week_of(day)" do
    subject { Payment.in_a_week_of(arg) }

    let(:week) { double("fiscal_week") }
    before do
      expect(FiscalDate).to receive(:locate_week) \
                        .with(arg) \
                        .and_return(week)
    end

    context "with Time" do
      let(:arg) { Time.now }

      it "calls .in with current week" do
        Payment.should_receive(:in).with(week).and_return [1,2,3]
        expect(subject).to eq [1,2,3]
      end
    end

    context "with Date" do
      let(:arg) { Date.today }

      it "calls .in with current week" do
        Payment.should_receive(:in).with(week).and_return [1,2,3]
        expect(subject).to eq [1,2,3]
      end
    end
  end

  describe ".in_this_week" do
    subject { Payment.in_this_week }

    let(:date) { Date.today }
    let(:week) { double("week") }

    before do
      allow(FiscalDate).to receive(:current_week) \
                       .and_return(week)
    end

    it "calls .in with current month" do
      Payment.should_receive(:in).with(week).and_return [1,2,3]
      expect(subject).to eq [1,2,3]
    end
  end

  describe ".in(fiscal_month_or_week)" do
    subject { Payment.in(arg) }

    let(:arg) { nil }

    context "with range" do
      let(:arg) { (Date.new(2013, 5, 1) .. Date.new(2013, 5, 31)) }

      it { should == Payment.where(paid_at: (Date.new(2013, 5, 1) .. Date.new(2013, 5, 31))) }
    end

    context "with fiscal cal" do
      let(:arg) { double("fiscal", range_in_time: (Date.new(2013, 5, 1) .. Date.new(2013, 5, 31))) }

      it { should == Payment.where(paid_at: (Date.new(2013, 5, 1) .. Date.new(2013, 5, 31))) }
    end
  end

  describe "#category", clean_db: true do
    let(:sub_category) { create(:sub_category) }
    let(:payment_new)  { create(:payment, sub_category: sub_category)  }
    let(:payment) { payment_new }

    subject { payment.category }

    it "returns category via sub_category" do
      expect(payment.category).to eq(sub_category.category)
    end

    context "when coming from .find" do
      let(:payment) { Payment.find(payment_new.id) }

      it "returns category via sub_category" do
        expect(payment.category).to eq(sub_category.category)
      end
    end

    context "when coming from relation" do
      let(:payment) { Payment.where(id: payment_new.id).first }

      it "returns category via sub_category" do
        expect(payment.category).to eq(sub_category.category)
      end
    end

    describe "reloading" do
      let(:another_sub_category) { create(:sub_category, name: '2') }

      it "can be reloaded" do
        payment.category # to load

        Payment.find(payment.id) \
               .update_attributes!(sub_category: another_sub_category)

        expect(payment.reload.category).to eq(another_sub_category.category)
      end
    end

    describe "saving" do
      it "can be saved" do
        payment.category # to load
        payment.comment = "Lunch"
        expect { payment.save! }.to_not raise_error
      end
    end
  end
end
