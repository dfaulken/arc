class AddNumberOfWarningsPerPenaltyPointToChampionships < ActiveRecord::Migration[6.1]
  def change
    add_column :championships, :number_of_warnings_per_penalty_point, :integer
  end
end
