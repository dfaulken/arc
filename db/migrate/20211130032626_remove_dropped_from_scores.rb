class RemoveDroppedFromScores < ActiveRecord::Migration[6.1]
  def change
    remove_column :scores, :dropped, :boolean
  end
end
