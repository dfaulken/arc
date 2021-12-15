class AddMostLapsLedToRaceResults < ActiveRecord::Migration[6.1]
  def change
    add_column :race_results, :most_laps_led, :boolean
  end
end
