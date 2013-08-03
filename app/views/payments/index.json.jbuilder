json.array!(@payments) do |payment|
  json.extract! payment, :place, :amount, :comment, :meta, :paid_at, :subcategory, :bill, :account
  json.url payment_url(payment, format: :json)
end
