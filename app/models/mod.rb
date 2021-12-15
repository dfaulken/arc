class Mod < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :confirmable, :registerable

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if approved?
      super
    else :not_approved
    end
  end
end
