json.array!(@expenses) do |expense|
  json.extract! expense, :place, :amount, :comment, :meta, :paid_at, :subcategory, :bill, :account
  json.url expense_url(expense, format: :json)
end
