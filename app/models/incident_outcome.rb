class IncidentOutcome < ApplicationRecord
  belongs_to :incident
  belongs_to :driver
  validates :penalty_points, numericality: { greater_than_or_equal_to: 0 }
  validates :explanation, presence: true
end
