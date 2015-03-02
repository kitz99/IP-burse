json.array!(@domains) do |domain|
  json.extract! domain, :id, :name, :money, :order_number, :scholarship_id
  json.url domain_url(domain, format: :json)
end
