require 'spec_helper'

describe Report::CategoryCollection do
  let(:month) { [2013, 9] }
  subject(:collection) { described_class.new(*month) }

  it "is enumerable" do
    expect(described_class.ancestors).to include(Enumerable)
  end

  describe "#month" do
    subject { collection.month }
    it { should eq 2013 }
  end

  describe "#year" do
    subject { collection.year }
    it { should eq 9 }
  end

  describe "#each" do
    let!(:categories) { create_list(:category, 2).sort_by(&:id) }

    context "without block" do
      subject { collection.each }
      it "returns Enumerator" do
        expect(subject).to be_a_kind_of(Enumerator)
        expect(subject.sort_by(&:id)).to eq categories
      end
    end

    it "yields all Report::Category-ies for each Category" do
      yielded_items = []
      collection.each do |item|
        expect(item).to be_a_kind_of(Report::Category)
        yielded_items << item
      end

      expect(yielded_items.map(&:id).sort).to eq(categories.map(&:id))
    end
  end

  describe "#[]" do
    let!(:categories) { create_list(:category, 2).sort_by(&:id) }

    it "returns Report::Category for specified month and category_id" do
      categories.each do |category|
        report = collection[category.id]
        expect(report).to be_a(Report::Category)
        expect(report.category).to eq category
      end
    end
  end
end
