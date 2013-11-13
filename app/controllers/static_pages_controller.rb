class StaticPagesController < ApplicationController
  def home
  	@game = TicTacToe.find(1)
  	@game.mark_comp_move(2)
  	@game.board = "100021200"
  	@game.print_board
  	@empty = @game.empty_slots(@game.board)
  	@game.possible_boards(@game.board)
  	@game.try_moves
  end
end
