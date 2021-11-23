class Score < ApplicationRecord
  belongs_to :race_result
  belongs_to :points_system

  validates :points, presence: true

  def calculate!
    points = points_system.points_for race_result.position
    if race_result.scored_pole_position?
      points += points_system.pole_position_points
    end
    if race_result.laps_led > 0
      points += points_system.any_lap_led_points
      if race_result.most_laps_led?
        points += points_system.most_laps_led_points
      end
    end
    if race_result.finished_race?
      points += points_system.race_finished_points
    end
  end
end
