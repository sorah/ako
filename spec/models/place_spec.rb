require 'spec_helper'

describe Place do
  describe "#candidates_for_expense" do
    let!(:place_a) { create(:place, name: 'らりる') }
    let!(:place_b) { create(:place, name: 'abb') }
    let!(:place_c) { create(:place, name: 'abc') }

    let(:query) { 'ab' }
    subject { Place.candidates_for_expense(query) }

    it "searchs by name using given query" do
      expect(subject.map(&:id)).to eq [place_b, place_c].map(&:id)
    end

    context "with :name_only" do
      subject { described_class.candidates_for_expense(query, name_only: true) }

      it "selects only id and name column" do
        expect { subject[0].longitude }.to \
          raise_error(ActiveModel::MissingAttributeError)
      end
    end

    context "with query in Japanese like" do
      let(:query) { 'らりr' }

      it "removes one trailing lowercase alphabet from query" do
        expect(subject.map(&:id)).to eq [place_a.id]
      end
    end

    context "with query from SKK user" do
      let(:query) { 'ら▽り' }

      it "removes string of SKK composition from query" do
        expect(subject.map(&:id)).to eq [place_a.id]
      end
    end
  end
end
