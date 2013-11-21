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
    #@game.turns_taken = ""
  	#@game.board = "000000000"
    #@move_2 = @game.user_move(0) #player's turn 3
    #@move_2 = @game.user_move(2) #player's turn 5
    #@move_2 = @game.user_move(3) #player's turn 7
    #@game.save
    
  	
    #@move_3 = @game.user_move(2)
  end

end
