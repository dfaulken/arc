json.extract! incident_outcome, :id, :incident_id, :driver_id, :received_warning, :penalty_points, :expires_at, :explanation, :published, :created_at, :updated_at
json.url incident_outcome_url(incident_outcome, format: :json)
