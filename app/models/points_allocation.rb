class PointsAllocation < ApplicationRecord
  belongs_to :points_system
  validates :position, presence: true
  validates :points, presence: true
end
