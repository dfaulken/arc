class AddDroppedToRaceResults < ActiveRecord::Migration[6.1]
  def change
    add_column :race_results, :dropped, :boolean
  end
end
