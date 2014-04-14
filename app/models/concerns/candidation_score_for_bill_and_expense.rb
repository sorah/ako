class CandidationScoreForBillAndExpense
  def initialize(bill, expense)
    @bill, @expense = bill, expense
  end

  attr_reader :bill, :expense

  def both_have_account?
    bill.account_id && expense.account_id
  end

  # Always false when both not have account
  def different_account?
    both_have_account? && expense.account_id != bill.account_id
  end

  def same_account?
    both_have_account? && expense.account_id == bill.account_id
  end

  def both_have_place?
    bill.place_id && expense.place_id
  end

  # Always false when both not have place
  def different_place?
    both_have_place? && expense.place_id != bill.place_id
  end

  def same_place?
    both_have_place? && expense.place_id == bill.place_id
  end

  def same_date?
    expense.paid_at.to_date == bill.billed_at.to_date
  end

  def same_amount?
    bill.amount == expense.amount
  end

  def amount_close?
    same_amount? || ((same_place? || same_date?) && (bill.amount - expense.amount).abs <= (bill.amount * 0.05))
  end

  def different_amount?
    !amount_close?
  end

  def no_mutuality?
    !same_place? && !same_account? && !same_date?
  end

  def different?
    different_account? || different_place? || different_amount?
  end

  def suitable?
    !(no_mutuality? || different?)
  end

  # rubocop:disable CyclomaticComplexity
  def score
    return unless suitable?
    score = 0

    score -= 100 if same_date?
    score -= 230 if same_place?
    score -= 120 if same_account?
    score -= 50 if amount_close?
    score -= 50 if same_amount?

    score
  end
  # rubocop:enable CyclomaticComplexity
end
