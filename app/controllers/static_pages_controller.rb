class StaticPagesController < ApplicationController
  def home
  	@game = TicTacToe.find(1)
  	#@game.board = "101021200"
  	#@game.board = "102020011"
  	#@game.board = "211020121"
  	#@game.board = "102020101"
  	#@game.board = "012001200"
    #@game.player_first = false
    #@best_move = @game.try_moves
    #@move = @game.start(0)
    #@hash = {}
    #@result_2 = @game.user_move(@hash, 1)
    #@hash_2 = @result_2[1]
    #@move_2 = @result_2[0]
    
  	@game.board = "000000012"
    @move_2 = @game.user_move(4) #player's turn 3
    @move_2 = @game.user_move(2) #player's turn 5
    @game.save
  	
    #@move_2 = @game.user_move(6) #player's turn 7
  	
    #@move_3 = @game.user_move(2)
  end

  def user_turn
    game = params[:game_id]
    move = params[:move]
    @move_3 = @game.user_move(3)
    @game.save
  end
end
