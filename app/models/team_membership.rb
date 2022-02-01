class TeamMembership < ApplicationRecord
  belongs_to :team
  belongs_to :season, through: :team
  belongs_to :driver

  validates :driver, uniqueness: { scope: :season }
end
