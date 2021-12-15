class AddApprovedToMods < ActiveRecord::Migration[6.1]
  def change
    add_column :mods, :approved, :boolean
  end
end
