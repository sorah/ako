require 'spec_helper'

describe DatetimeParameterHandler do
  include DatetimeParameterHandler

  describe "#process_time_param" do
    subject { process_time_param(arg) }
    let(:expected) { Time.utc(2013,8,31,14,30,0).localtime }
    let(:arg) { "" }

    context "with string only in digits" do
      let(:arg) { '1377959400' }

      it "handles as epoch time" do
        expect(subject).to be_a_kind_of(Time)
        expect(subject).to eq expected
        expect(subject.utc_offset).to eq expected.utc_offset
      end
    end

    context "with string like xmlschema (+0800)" do
      let(:arg) { "2013-08-31T22:30:00+08:00" }

      it "handles as epoch time" do
        expect(subject).to be_a_kind_of(Time)
        expect(subject).to eq expected
        expect(subject.utc_offset).to eq expected.utc_offset
      end
    end

    context "with string like xmlschema (+0900)" do
      let(:arg) { "2013-08-31T23:30:00+09:00" }

      it "handles as epoch time" do
        expect(subject).to be_a_kind_of(Time)
        expect(subject).to eq expected
        expect(subject.utc_offset).to eq expected.utc_offset
      end
    end

    context "with string parsable with Time.parse" do
      let(:arg) { "2013/08/31 14:30:00 UTC" }

      it "handles as epoch time" do
        expect(subject).to be_a_kind_of(Time)
        expect(subject).to eq expected
        expect(subject.utc_offset).to eq expected.utc_offset
      end
    end

    context "with invalid string" do
      let(:arg) { 'foobar' }
      it { should be_nil }
    end
  end
end
