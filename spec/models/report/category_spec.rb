require 'spec_helper'

describe Report::Category do
  let(:month) { [2013, 9] }
  let(:category) { create(:category, :with_sub_categories) }
  let(:category_arg) { category }

  subject(:report) { described_class.new(*month, category_arg) }

  describe "#month" do
    subject { report.month }
    it { should eq 2013 }
  end

  describe "#year" do
    subject { report.year }
    it { should eq 9 }
  end

  describe "#category" do
    subject { report.category }
    it { should eq category }
  end

  describe "#id" do
    subject { report.id }
    it { should eq category.id }
  end
end
