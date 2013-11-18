class AddTurnsTakenToGame < ActiveRecord::Migration
  def change
  	add_column :tic_tac_toes, :turns_taken, :string, default: ""
  end
end
