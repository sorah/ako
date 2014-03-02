require 'spec_helper'

describe Report::Common, :clean_db do
  let(:testee_class) do
    Class.new {
      include Report::Common

      def expenses
        Expense.all
      end
    }
  end

  subject(:testee) { testee_class.new }

  let!(:category_variable) { create(:category, name: 'var', fixed: false) }
  let!(:sub_category_a) { create(:sub_category, name: 'a', category: category_variable) }
  let!(:sub_category_b) { create(:sub_category, name: 'b', category: category_variable) }

  let!(:category_fixed) { create(:category, name: 'fix', fixed: true) }
  let!(:sub_category_c) { create(:sub_category, name: 'c', category: category_fixed) }
  let!(:sub_category_d) { create(:sub_category, name: 'd', category: category_fixed) }

  before do
    create(:expense, sub_category: sub_category_a, amount: 40)
    create(:expense, sub_category: sub_category_a, amount: 42)
    create(:expense, sub_category: sub_category_b, amount: 4100)
    create(:expense, sub_category: sub_category_b, amount: 142)
    create(:expense, sub_category: sub_category_c, amount: 40)
    create(:expense, sub_category: sub_category_c, amount: 2)
    create(:expense, sub_category: sub_category_d, amount: 4000)
    create(:expense, sub_category: sub_category_d, amount: 242)

  end

  describe "#total_expense" do
    subject { testee.total_expense }

    it { should eq Expense.all.pluck(:amount).inject(:+) }
  end

  describe "#total_fixed_expense" do
    subject { testee.total_fixed_expense }

    it { should eq category_fixed.expenses.pluck(:amount).inject(:+) }
  end

  describe "#total_variable_expense" do
    subject { testee.total_variable_expense }

    it { should eq category_variable.expenses.pluck(:amount).inject(:+) }
  end

  describe "#expenses_include_categories" do
    subject { testee.expenses_include_categories }

    it { should eq Expense.all.includes(sub_category: :category) }

    it "memoizes" do
      expect(subject.object_id).to eq \
        testee.expenses_include_categories.object_id
      expect(subject.object_id).not_to eq \
        testee.expenses_include_categories(:reload).object_id

    end
  end

  describe "#categories" do
    subject { testee.categories }

    it { should eq Report::Common::CategoriesReport.new(testee) }

    specify {
      category_variable_sum = category_variable.expenses.pluck(:amount).inject(:+)
      category_fixed_sum = category_fixed.expenses.pluck(:amount).inject(:+)
      sub_category_a_sum = sub_category_a.expenses.pluck(:amount).inject(:+)
      sub_category_b_sum = sub_category_b.expenses.pluck(:amount).inject(:+)
      sub_category_c_sum = sub_category_c.expenses.pluck(:amount).inject(:+)
      sub_category_d_sum = sub_category_d.expenses.pluck(:amount).inject(:+)

      expect(subject[category_variable.id][:category]).to eq category_variable
      expect(subject[category_variable.id][:amount]).to eq category_variable_sum
      expect(subject[category_variable.id][:fixed_amount]).to eq 0
      expect(subject[category_variable.id][:variable_amount]).to eq category_variable_sum
      expect(subject[category_variable.id][:sub_categories][sub_category_a.id][:sub_category]).to eq sub_category_a
      expect(subject[category_variable.id][:sub_categories][sub_category_a.id][:amount]).to eq sub_category_a_sum
      expect(subject[category_variable.id][:sub_categories][sub_category_a.id][:variable_amount]).to eq sub_category_a_sum
      expect(subject[category_variable.id][:sub_categories][sub_category_a.id][:fixed_amount]).to eq 0
      expect(subject[category_variable.id][:sub_categories][sub_category_b.id][:sub_category]).to eq sub_category_b
      expect(subject[category_variable.id][:sub_categories][sub_category_b.id][:amount]).to eq sub_category_b_sum
      expect(subject[category_variable.id][:sub_categories][sub_category_b.id][:variable_amount]).to eq sub_category_b_sum
      expect(subject[category_variable.id][:sub_categories][sub_category_b.id][:fixed_amount]).to eq 0

      expect(subject[category_fixed.id][:category]).to eq category_fixed
      expect(subject[category_fixed.id][:amount]).to eq category_fixed_sum
      expect(subject[category_fixed.id][:variable_amount]).to eq 0
      expect(subject[category_fixed.id][:fixed_amount]).to eq category_fixed_sum
      expect(subject[category_fixed.id][:sub_categories][sub_category_c.id][:sub_category]).to eq sub_category_c
      expect(subject[category_fixed.id][:sub_categories][sub_category_c.id][:amount]).to eq sub_category_c_sum
      expect(subject[category_fixed.id][:sub_categories][sub_category_c.id][:fixed_amount]).to eq sub_category_c_sum
      expect(subject[category_fixed.id][:sub_categories][sub_category_c.id][:variable_amount]).to eq 0
      expect(subject[category_fixed.id][:sub_categories][sub_category_d.id][:sub_category]).to eq sub_category_d
      expect(subject[category_fixed.id][:sub_categories][sub_category_d.id][:amount]).to eq sub_category_d_sum
      expect(subject[category_fixed.id][:sub_categories][sub_category_d.id][:fixed_amount]).to eq sub_category_d_sum
      expect(subject[category_fixed.id][:sub_categories][sub_category_d.id][:variable_amount]).to eq 0
    }
  end
end
