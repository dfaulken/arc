class CreatePointsSystems < ActiveRecord::Migration[6.1]
  def change
    create_table :points_systems do |t|
      t.string :name
      t.integer :worst_rounds_dropped
      t.integer :pole_position_points
      t.integer :any_lap_led_points
      t.integer :most_lap_led_points
      t.integer :race_finished_points

      t.timestamps
    end
  end
end
