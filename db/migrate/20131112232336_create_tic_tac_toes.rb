class CreateTicTacToes < ActiveRecord::Migration
  def change
    create_table :tic_tac_toes do |t|
      t.string :board
      t.boolean :player_first

      t.timestamps
    end
  end
end
