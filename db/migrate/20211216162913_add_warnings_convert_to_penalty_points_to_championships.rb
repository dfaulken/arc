class AddWarningsConvertToPenaltyPointsToChampionships < ActiveRecord::Migration[6.1]
  def change
    add_column :championships, :warnings_convert_to_penalty_points, :boolean
  end
end
