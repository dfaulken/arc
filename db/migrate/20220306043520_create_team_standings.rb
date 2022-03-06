class CreateTeamStandings < ActiveRecord::Migration[6.1]
  def change
    create_table :team_standings do |t|
      t.integer :team_id
      t.integer :position
      t.integer :points
      t.string :track_type

      t.timestamps
    end
  end
end
