class ChangeMostLapLedPointsToMostLapsLedPointsInPointsSystems < ActiveRecord::Migration[6.1]
  def change
    rename_column :points_systems, :most_lap_led_points, :most_laps_led_points
  end
end
