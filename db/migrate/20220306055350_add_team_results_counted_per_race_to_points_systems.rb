class AddTeamResultsCountedPerRaceToPointsSystems < ActiveRecord::Migration[6.1]
  def change
    add_column :points_systems, :team_results_counted_per_race, :integer
  end
end
