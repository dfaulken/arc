class PointsAllocation < ApplicationRecord
  belongs_to :points_system
  validates :position, presence: true
  validates :points, presence: true

  default_scope { order :position }

end
