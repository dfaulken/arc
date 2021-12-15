class DroppedRace < ApplicationRecord
  belongs_to :race_result
  belongs_to :season_standing

  def points
    race_result.score.points
  end
end
