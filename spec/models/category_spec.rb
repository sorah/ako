require 'spec_helper'

describe Category do
  describe "#expenses", :ar_log do
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
end
