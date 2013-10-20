require 'spec_helper'
# require 'fiscal_date'

describe FiscalDate do
  shared_context "when fiscal month starts 15th" do
    before { Option[:month_starts] = 15 }
    after  { Option.delete :month_starts }
  end

  shared_context "when fiscal week starts Friday" do
    before { Option[:week_starts] = 5 }
    after  { Option.delete :week_starts }
  end

  describe ".locate" do
    let(:date) { Date.new(2013, 5, 14) }
    subject { FiscalDate.locate(date) }

    specify do
      month = FiscalDate::Month.new(2013, 5)
      should == [month.weeks[2], month]
    end

    context "with month_starts option" do
      include_context "when fiscal month starts 15th"

      context "(before starting day)" do
        let(:date) { Date.new(2013, 5, 14) }

        specify do
          month = FiscalDate::Month.new(2013, 4)
          should == [month.weeks[4], month]
        end
      end

      context "(just starting day)" do
        let(:date) { Date.new(2013, 5, 15) }

        specify do
          month = FiscalDate::Month.new(2013, 5)
          should == [month.weeks[0], month]
        end
      end

      context "(after starting day)" do
        let(:date) { Date.new(2013, 5, 21) }

        specify do
          month = FiscalDate::Month.new(2013, 5)
          should == [month.weeks[1], month]
        end
      end
    end

    context "with week_starts option" do
      include_context "when fiscal week starts Friday"

      context "(before starting day)" do
        let(:date) { Date.new(2013, 5, 16) }

        specify do
          month = FiscalDate::Month.new(2013, 5)
          should == [month.weeks[2], month]
        end
      end

      context "(just starting day)" do
        let(:date) { Date.new(2013, 5, 17) }

        specify do
          month = FiscalDate::Month.new(2013, 5)
          should == [month.weeks[3], month]
        end
      end

      context "(after starting day)" do
        let(:date) { Date.new(2013, 5, 18) }

        specify do
          month = FiscalDate::Month.new(2013, 5)
          should == [month.weeks[3], month]
        end
      end
    end
  end

  describe ".today" do
    let(:date) { Date.today }
    before do
      Date.stub(today: date)
      FiscalDate.should_receive(:locate) \
                .with(date) \
                .and_return([:w, :m])
    end

    subject { FiscalDate.today }

    it { should == [:w, :m] }
  end

  describe ".locate_week" do
    before do
      allow(FiscalDate).to receive(:locate) \
                          .and_return([:w, :m])
    end

    subject { FiscalDate.locate_week(Time.now) }

    it { should == :w }
  end

  describe ".locate_month" do
    before do
      allow(FiscalDate).to receive(:locate) \
                          .and_return([:w, :m])
    end

    subject { FiscalDate.locate_month(Time.now) }

    it { should == :m }
  end

  describe ".current_week" do
    before do
      allow(FiscalDate).to receive(:today) \
                          .and_return([:w, :m])
    end

    subject { FiscalDate.current_week }

    it { should == :w }
  end

  describe ".current_month" do
    before do
      allow(FiscalDate).to receive(:today) \
                          .and_return([:w, :m])
    end

    subject { FiscalDate.current_month }

    it { should == :m }
  end

  describe FiscalDate::Month do
    subject(:may) { FiscalDate::Month.new(2013, 5) }

    describe ".in(year)" do
      subject { FiscalDate::Month.in(2013) }

      it "has 12 months" do
        subject.should be_a_kind_of(Array)
        subject.size.should == 12

        subject.map(&:number).should == (1..12).to_a
      end

      context "with month_starts option" do
        include_context "when fiscal month starts 15th"

        it "has 12 months" do
          subject.should be_a_kind_of(Array)
          subject.size.should == 12

          subject.map(&:number).should == (1..12).to_a
        end
      end
    end

    describe "#month (#number)" do
      subject { may.month }
      it { should == 5 }
    end

    describe "#begin" do
      subject { may.begin }

      it { should == Date.new(2013, 5, 1) }


      context "with month_starts option" do
        include_context "when fiscal month starts 15th"

        it { should == Date.new(2013, 5, 15) }
      end
    end

    describe "#end" do
      subject { may.end }

      it { should == Date.new(2013, 5, 31) }


      context "with month_starts option" do
        include_context "when fiscal month starts 15th"

        it { should == Date.new(2013, 6, 14) }
      end
    end

    describe "#range" do
      subject { may.range }

      it { should == (Date.new(2013, 5, 1)..Date.new(2013, 5, 31)) }

      context "with month_starts option" do
        include_context "when fiscal month starts 15th"

        it { should == (Date.new(2013, 5, 15)..Date.new(2013, 6, 14)) }
      end
    end

    describe "#range_in_time" do
      subject { may.range_in_time }

      it { should == \
        (Date.new(2013, 5, 1).beginning_of_day.localtime ...
         Date.new(2013, 6, 1).beginning_of_day.localtime) }

      context "with month_starts option" do
        include_context "when fiscal month starts 15th"

        it { should == \
          (Date.new(2013, 5, 15).beginning_of_day.localtime ...
           Date.new(2013, 6, 15).beginning_of_day.localtime) }
      end
    end

    describe "#days" do
      subject { may.days }

      it { should == (Date.new(2013, 5, 1)..Date.new(2013, 5, 31)).to_a }

      context "with month_starts option" do
        include_context "when fiscal month starts 15th"

        it { should == (Date.new(2013, 5, 15)..Date.new(2013, 6, 14)).to_a }
      end
    end

    describe "#weeks" do
      before do
        FiscalDate::Week.should_receive(:in).with(may) \
                        .and_return([1,2,3])
      end

      subject { may.weeks }

      it { should == [1, 2, 3] }
    end

    describe "#==" do
      specify { (may == may).should be_true }
      specify { (may == FiscalDate::Month.new(2013, 5)).should be_true }

      specify { (may == FiscalDate::Month.new(2013, 4)).should be_false }
      specify { (may == FiscalDate::Month.new(2013, 4)).should be_false }
    end
  end

  describe FiscalDate::Week do
    let(:may) { FiscalDate::Month.new(2013, 5) }
    subject(:week)   { FiscalDate::Week.new(may, 1, Date.new(2013,5,1)..Date.new(2013,5,4)) }

    describe ".in(month)" do
      subject(:weeks) { FiscalDate::Week.in(may) }

      it "returns weeks" do
        expect(weeks.map(&:range)).to eq([
          Date.new(2013,5, 1)..Date.new(2013,5, 4),
          Date.new(2013,5, 5)..Date.new(2013,5,11),
          Date.new(2013,5,12)..Date.new(2013,5,18),
          Date.new(2013,5,19)..Date.new(2013,5,25),
          Date.new(2013,5,26)..Date.new(2013,5,31),
        ])
      end

      context "with month_starts option" do
        include_context "when fiscal month starts 15th"

        it "returns weeks" do
          expect(weeks.map(&:range)).to eq([
            Date.new(2013,5,15)..Date.new(2013,5,18),
            Date.new(2013,5,19)..Date.new(2013,5,25),
            Date.new(2013,5,26)..Date.new(2013,6, 1),
            Date.new(2013,6, 2)..Date.new(2013,6, 8),
            Date.new(2013,6, 9)..Date.new(2013,6,14),
          ])
        end
      end

      context "with week_starts option" do
        include_context "when fiscal week starts Friday"

        it "returns weeks" do
          expect(weeks.map(&:range)).to eq([
            Date.new(2013,5, 1)..Date.new(2013,5, 2),
            Date.new(2013,5, 3)..Date.new(2013,5, 9),
            Date.new(2013,5,10)..Date.new(2013,5,16),
            Date.new(2013,5,17)..Date.new(2013,5,23),
            Date.new(2013,5,24)..Date.new(2013,5,30),
            Date.new(2013,5,31)..Date.new(2013,5,31),
          ])
        end
      end

      context "with month and week_starts option" do
        include_context "when fiscal month starts 15th"
        include_context "when fiscal week starts Friday"

        it "returns weeks" do
          expect(weeks.map(&:range)).to eq([
            Date.new(2013,5,15)..Date.new(2013,5,16),
            Date.new(2013,5,17)..Date.new(2013,5,23),
            Date.new(2013,5,24)..Date.new(2013,5,30),
            Date.new(2013,5,31)..Date.new(2013,6, 6),
            Date.new(2013,6, 7)..Date.new(2013,6,13),
            Date.new(2013,6,14)..Date.new(2013,6,14),
          ])
        end
      end
    end

    describe "#month" do
      subject { week.month }
      it { should == may }
    end

    describe "#number (#week)" do
      subject { week.number }
      it { should == 1 }
    end

    describe "#range" do
      subject { week.range }
      it { should == (Date.new(2013,5,1)..Date.new(2013,5,4)) }
    end

    describe "#range_in_time" do
      subject { week.range_in_time }
      it { should == (Date.new(2013,5,1).beginning_of_day.localtime ... \
                      Date.new(2013,5,5).beginning_of_day.localtime) }

    end

    describe "#days" do
      subject { week.days }
      it { should == (Date.new(2013,5,1)..Date.new(2013,5,4)).to_a }
    end

    describe "#==" do
      specify { (week == week).should be_true }
      specify { (week == FiscalDate::Week.new(may, 1, Date.new(2013,5,1)..Date.new(2013,5,4))).should be_true }

      specify { (week == Object.new).should be_false }
      specify { (week == FiscalDate::Week.new(may, 2, Date.new(2013,5,1)..Date.new(2013,5,4))).should be_false }
    end
  end
end
