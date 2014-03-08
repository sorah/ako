json.array!(@bills) do |bill|
  json.extract! bill, :amount, :title, :billed_at, :meta, :place_id, :account_id, :expense_id
  json.url bill_url(bill, format: :json)
end
