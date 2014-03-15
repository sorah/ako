require 'spec_helper'

describe PlaceNameAccessor do
  let(:klass) {
    Class.new do
      include PlaceNameAccessor

      attr_accessor :place
    end
  }
  describe "#place_name" do
    subject { klass.new }

    context "when specified" do
      context "and place exists" do
        it "sets place_id" do
          place = create(:place)

          expect {
            subject.place_name = place.name
          }.to change { subject.place }.to(place)
        end
      end

      context "and place doesn't exist" do
        it "creates place" do
          expect {
            subject.place_name = 'somewhere'
          }.to change { Place.count }.by(1)

          expect(Place.last.name).to eq 'somewhere'
          expect(subject.place).to eq Place.last
        end
      end
    end

    context "when not specified" do
      context "and place_id is present" do
        before do
          subject.place = create(:place)
        end

        it "leaves place as is" do
          expect {
            subject.place_name = ""
          }.to_not change { subject.place }
        end
      end
    end
  end
end
