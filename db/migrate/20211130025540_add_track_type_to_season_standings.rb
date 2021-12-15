class AddTrackTypeToSeasonStandings < ActiveRecord::Migration[6.1]
  def change
    add_column :season_standings, :track_type, :string
  end
end
