class AddDroppedToScores < ActiveRecord::Migration[6.1]
  def change
    add_column :scores, :dropped, :boolean
  end
end
