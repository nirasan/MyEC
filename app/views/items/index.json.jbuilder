json.array!(@items) do |item|
  json.extract! item, :id, :name, :price, :description, :show_flag, :show_priority
  json.url item_url(item, format: :json)
end
