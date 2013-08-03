json.array!(@accounts) do |account|
  json.extract! account, :name, :meta
  json.url account_url(account, format: :json)
end
