json.extract! incident, :id, :race_id, :lap_number, :reported_by, :drivers_involved, :description, :created_at, :updated_at
json.url incident_url(incident, format: :json)
