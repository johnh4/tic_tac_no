class StaticPagesController < ApplicationController
  def home
  	@game = TicTacToe.find(1)
  	#@game.board = "101021200"
  	#@game.board = "102020011"
  	#@game.board = "211020121"
  	#@game.board = "102020101"
  	#@game.board = "012001200"
  	@game.board = "100000000"
  	#@game.player_first = false
  	#@best_move = @game.try_moves
  	@game.start
  end
end
