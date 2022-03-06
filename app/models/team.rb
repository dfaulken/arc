class Team < ApplicationRecord
  belongs_to :season
  has_many :team_memberships
  has_many :drivers, through: :team_memberships
end
