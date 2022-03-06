class RemoveNicknameFromDrivers < ActiveRecord::Migration[6.1]
  def change
    remove_column :drivers, :nickname, :string
  end
end
