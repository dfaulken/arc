class ChangeScoreToPointsInScores < ActiveRecord::Migration[6.1]
  def change
    rename_column :scores, :score, :points
  end
end
