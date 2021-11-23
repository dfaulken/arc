class CreateRaceResults < ActiveRecord::Migration[6.1]
  def change
    create_table :race_results do |t|
      t.integer :race_id
      t.integer :driver_id
      t.boolean :scored_pole_position
      t.integer :laps_led
      t.boolean :finished_race

      t.timestamps
    end
  end
end
