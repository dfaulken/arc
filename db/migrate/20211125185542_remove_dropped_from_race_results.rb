class RemoveDroppedFromRaceResults < ActiveRecord::Migration[6.1]
  def change
    remove_column :race_results, :dropped, :boolean
  end
end
