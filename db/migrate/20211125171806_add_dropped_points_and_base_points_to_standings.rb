class AddDroppedPointsAndBasePointsToStandings < ActiveRecord::Migration[6.1]
  def change
    add_column :season_standings, :dropped_points, :integer
    add_column :season_standings, :base_points, :integer
  end
end
