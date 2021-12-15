class CreateSeasonStandings < ActiveRecord::Migration[6.1]
  def change
    create_table :season_standings do |t|
      t.integer :season_id
      t.integer :driver_id
      t.integer :points
      t.integer :position

      t.timestamps
    end
  end
end
