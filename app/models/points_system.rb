class PointsSystem < ApplicationRecord
  has_many :points_allocations, dependent: :destroy
  has_many :seasons, dependent: :restrict_with_error

  accepts_nested_attributes_for :points_allocations

  validates :name, presence: true, uniqueness: true
  validates :worst_rounds_dropped, presence: true
  validates :pole_position_points, presence: true
  validates :any_lap_led_points, presence: true
  validates :most_laps_led_points, presence: true
  validates :race_finished_points, presence: true
  validates :team_results_counted_per_race, presence: true

  def drops_rounds?
    worst_rounds_dropped > 0
  end

  def max_possible_points_per_race
    points_allocations.pluck(:points).max +
      pole_position_points +
      any_lap_led_points + 
      most_laps_led_points + 
      race_finished_points
  end

  def points_for(position)
    points_allocations.find_by(position: position).points
  end
end
