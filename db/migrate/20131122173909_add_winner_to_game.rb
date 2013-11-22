class AddWinnerToGame < ActiveRecord::Migration
  def change
  	add_column :tic_tac_toes, :winner, :string, default: "0"
  end
end
