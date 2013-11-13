class StaticPagesController < ApplicationController
  def home
  	@game = TicTacToe.find(1)
  	#@game.board = "101021200"
  	#@game.board = "102220111"
  	@game.board = "211020121"
  	@best_move = @game.try_moves
  end
end
