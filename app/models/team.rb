class Team < ApplicationRecord
  belongs_to :season
  has_many :team_memberships
  has_many :drivers, through: :team_memberships
  has_many :team_standings

  validates :name, presence: true, uniqueness: { scope: :season }

  def driver_list
    drivers.pluck(:name).join ', '
  end
end
