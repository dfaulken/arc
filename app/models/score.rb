class Score < ApplicationRecord
  belongs_to :race_result
  belongs_to :points_system

  validates :points, presence: true
  validates :points_system, uniqueness: { scope: :race_result }

  def calculate!
    self.points = points_system.points_for race_result.position
    if race_result.scored_pole_position?
      self.points += points_system.pole_position_points
    end
    if race_result.laps_led > 0
      self.points += points_system.any_lap_led_points
    end
    if race_result.most_laps_led?
      self.points += points_system.most_laps_led_points
    end
    if race_result.finished_race?
      self.points += points_system.race_finished_points
    end
  end
end
