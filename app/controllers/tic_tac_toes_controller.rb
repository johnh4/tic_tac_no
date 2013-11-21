class TicTacToesController < ApplicationController
  include TicTacToesHelper
  def new
  	@game = TicTacToe.new
  end

  def create
  	@game = TicTacToe.new(tic_tac_toe_params)
  	if @game.save
  		flash[:success] = "Game started!"
  		redirect_to @game
  	else
  		redirect_to root_path
  	end
  end

  def show
  	@game = TicTacToe.find(params[:id])
  end

  def update
  	@game = TicTacToe.find(params[:id])
  	if @game.update(tic_tac_toe_params)
  		flash[:success] = "Game updated!"
  		redirect_to @game
  	else
  		flash[:error] = "Game failed to update."
  		redirect_to @game
  	end
  end

  def user_turn
    @game = TicTacToe.find(params[:id])
    prev_board = copy_board(@game.board)
    move = params[:move].to_i
    #@game.board[@game.user_move(move)] = "2" #if @game.board[move] == "0"
    #new_board = @game.board
    #@game.update(board: new_board)
    if @game.board[move] == "0"
      @comp_move = @game.user_move(move)
      prev_board[move] = "1"
      prev_board[@comp_move] = "2"
    end
    @game.board = ""
    @game.save
    if @game.update(board: copy_board(prev_board))
      redirect_to @game
      #render json: @game
    else
      puts "not saved"
      redirect_to root_path
    end
  end


  private

  	def tic_tac_toe_params
  		params.require(:tic_tac_toe).permit(:board, :player_first, :id, :move)
  	end

end
