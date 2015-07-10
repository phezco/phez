json.array!(@subphezs) do |subphez|
  json.extract! subphez, :id, :path, :title, :sidebar
  json.url subphez_url(subphez, format: :json)
end
