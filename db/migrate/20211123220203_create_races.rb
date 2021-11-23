class CreateRaces < ActiveRecord::Migration[6.1]
  def change
    create_table :races do |t|
      t.integer :season_id
      t.integer :track_id
      t.date :date
      t.integer :index
      t.integer :laps

      t.timestamps
    end
  end
end
