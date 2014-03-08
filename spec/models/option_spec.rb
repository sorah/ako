require 'spec_helper'

describe Option, :clean_db do
  describe "#key" do
    subject { Option.new(tag: 'foo').key }

    it { should == 'foo' }
  end

  describe "#value" do
    let(:obj) do
      Object.new.tap do |o|
        o.instance_variable_set(:@foo, 'bar')
      end
    end

    subject do
      Option.new(val: Marshal.dump(obj)) \
            .value \
            .instance_variable_get(:@foo)
    end

    it { should == 'bar' }
  end

  describe ".[]" do
    before { Option.create!(tag: 'foo', val: Marshal.dump("bar")) }
    subject { Option[:foo] }

    it "returns the value for key" do
      subject.should == 'bar'
    end

    context "with default value" do
      let(:key_name) { :"options_default_test_#{$$}#{Time.now.to_i}" }
      before do
        Option.default key_name => 'default'
      end

      it "returns default value if not set" do
        expect { Option[key_name] = 'bar' } \
          .to change { Option[key_name] } \
          .from('default').to('bar')
      end
    end
  end

  describe ".[]=" do
    it "saves the value for key" do
      expect {
        Option[:hoge] = 'huga'
      }.to change { Option.where(tag: 'hoge').first.try(:val) } \
       .from(nil).to(Marshal.dump('huga'))
      Option[:hoge].should == 'huga'
    end
  end

  describe ".delete" do
    before { Option.create!(tag: 'foo', val: Marshal.dump("bar")) }

    it "deletes the key" do
      expect {
        Option.delete(:foo)
      }.to change { Option.where(tag: 'foo').first } \
        .to(nil)
      Option[:foo].should be_nil
    end
  end

  after do
    begin
      Rails.cache.clear
    rescue Errno::ENOENT
    end
  end
end
