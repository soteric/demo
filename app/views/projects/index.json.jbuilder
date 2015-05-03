json.array!(@projects) do |project|
  json.extract! project, :id, :name, :release_id, :scope_id, :team_id
  json.url project_url(project, format: :json)
end
