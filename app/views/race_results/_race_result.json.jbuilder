json.extract! race_result, :id, :race_id, :driver_id, :scored_pole_position, :laps_led, :finished_race, :created_at, :updated_at
json.url race_result_url(race_result, format: :json)
