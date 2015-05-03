json.array!(@releases) do |release|
  json.extract! release, :id, :name
  json.url release_url(release, format: :json)
end
