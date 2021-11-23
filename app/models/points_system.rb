class PointsSystem < ApplicationRecord
  has_many :points_allocations
  has_many :seasons

  validates :name, presence: true, uniqueness: true
  validates :worst_rounds_dropped, presence: true
  validates :pole_position_points, presence: true
  validates :any_lap_led_points, presence: true
  validates :most_laps_led_points, presence: true
  validates :race_finished_points, presence: true

  def points_for(position)
    points_allocations.find_by(position: position).points
  end
end
