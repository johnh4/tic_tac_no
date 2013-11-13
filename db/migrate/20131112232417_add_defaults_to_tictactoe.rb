class AddDefaultsToTictactoe < ActiveRecord::Migration
  def change
  	change_column :tic_tac_toes, :board, :string, default: "00000000"
  	change_column :tic_tac_toes, :player_first, :boolean, default: true
  end
end
