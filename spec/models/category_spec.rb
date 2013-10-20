require 'spec_helper'

describe Category do
  describe "#payments", :ar_log do
    let(:category) { create(:category, :with_sub_categories) }

    let!(:payments) do
      category.sub_categories.flat_map.with_index do |sc, i|
        i.times.map do
          create(:payment, sub_category_id: sc.id)
        end
      end
    end

    subject { category.payments }

    it "returns payments in all sub categories" do
      expect(subject).to eq payments
    end
  end
end
