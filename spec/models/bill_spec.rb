require 'spec_helper'

describe Bill do
  it "assigns billed_at automatically for new record" do
    bill = Bill.new(amount: 100)
    bill.save!
    expect(bill.billed_at).not_to be_nil

    bill.billed_at = false
    bill.save
    expect(bill).to have(1).errors_on(:billed_at)
  end
end
