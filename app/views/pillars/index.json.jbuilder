json.array!(@pillars) do |pillar|
  json.extract! pillar, :id, :name
  json.url pillar_url(pillar, format: :json)
end
