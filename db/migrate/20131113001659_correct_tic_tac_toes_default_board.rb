class CorrectTicTacToesDefaultBoard < ActiveRecord::Migration
  def change
  	change_column :tic_tac_toes, :board, :string, default: "000000000"
  end
end
