class CreateDroppedRaces < ActiveRecord::Migration[6.1]
  def change
    create_table :dropped_races do |t|
      t.integer :race_result_id
      t.integer :season_standing_id

      t.timestamps
    end
  end
end
