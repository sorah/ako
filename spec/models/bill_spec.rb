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

  describe "#expense_candidates" do
    let(:bill) { Bill.new(amount: 100, billed_at: Time.new(2014, 3, 1, 0, 0, 0)) }
    subject { bill.expense_candidates }

    # all within 1 day,  with 5% accuracy of amount

    it "shows expense that paid same amount" do
      account = create(:account)
      bill.account = account

      expense_a = create(:expense, amount: 100, account: account, paid_at: bill.billed_at)
      expense_b = create(:expense, amount: 200, account: account, paid_at: bill.billed_at)
      expense_c = create(:expense, amount: 100, account: account, paid_at: bill.billed_at + 2.days)
      expense_d = create(:expense, amount: 100, account: account, paid_at: bill.billed_at - 2.days)

      expect(subject).to eq [expense_a, expense_c, expense_d]
    end

    it "doesn't show expense that paid same account, but not billed on same day" do
      account = create(:account)
      bill.account = account

      expense_a = create(:expense, amount: 100, paid_at: bill.billed_at)
      expense_b = create(:expense, amount: 100, paid_at: bill.billed_at - 1.day)
      expense_c = create(:expense, amount: 100, account: account, paid_at: bill.billed_at - 1.day)

      expect(subject).to eq [expense_c, expense_a]
    end

    it "shows paid by same account" do
      account_a = create(:account, name: 'account a')
      account_b = create(:account, name: 'account b')
      expense_a = create(:expense, account: account_a, amount: 102, paid_at: bill.billed_at)
      expense_b = create(:expense, account: account_b, amount: 102, paid_at: bill.billed_at)
      expense_c = create(:expense, account: account_a, amount: 100, paid_at: bill.billed_at + 2.days)
      expense_d = create(:expense, account: account_b, amount: 100, paid_at: bill.billed_at - 2.days)

      bill.account = account_a

      expect(subject).to eq [expense_a, expense_c]
    end

    it "shows paid in same place as billed" do
      place_a = create(:place, name: 'a')
      place_b = create(:place, name: 'b')
      expense_a = create(:expense, amount: 100, place: place_a, paid_at: bill.billed_at)
      expense_b = create(:expense, amount: 100, place: place_b, paid_at: bill.billed_at)

      bill.place = place_a

      expect(subject).to eq [expense_a]
    end

    it "calculates scores then sort candidates properly" do
      place = create(:place, name: 'a')
      account = create(:account, name: 'a')
      bill.place = place
      bill.account = account

      expenses = []
      expenses << create(:expense, comment: :a, amount: 100, place: place, account: account, paid_at: bill.billed_at)
      expenses << create(:expense, comment: :b, amount: 102, place: place, account: account, paid_at: bill.billed_at)
      expenses << create(:expense, comment: :c, amount: 100, place: place, account: account, paid_at: bill.billed_at - 1.days)
      expenses << create(:expense, comment: :d, amount: 100, place: place, paid_at: bill.billed_at)
      expenses << create(:expense, comment: :e, amount: 102, place: place, paid_at: bill.billed_at)
      expenses << create(:expense, comment: :f, amount: 100, place: place, paid_at: bill.billed_at - 1.days)
      expenses << create(:expense, comment: :g, amount: 100, account: account, paid_at: bill.billed_at)
      expenses << create(:expense, comment: :h, amount: 102, account: account, paid_at: bill.billed_at)
      expenses << create(:expense, comment: :i, amount: 100, account: account, paid_at: bill.billed_at - 1.days)
      expenses << create(:expense, comment: :j, amount: 100, paid_at: bill.billed_at)

      expect(subject.sort_by(&:id)).to eq expenses.sort_by(&:id)
      expect(subject.map(&:id)).to eq expenses.map(&:id)
      expect(subject).to eq expenses
    end
  end
end
