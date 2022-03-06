class TeamStanding < ApplicationRecord
  belongs_to :team

  validates :team, uniqueness: { scope: :track_type }
  validates :points, presence: true
  validates :position, presence: true
  validates :track_type, presence: true, allow_blank: true,
    uniqueness: { scope: :team }
end
