class TicTacToesController < ApplicationController
  include TicTacToesHelper

  def new
  	@game = TicTacToe.new
  end

  def index
    @games = TicTacToe.all
    render json: @games
  end

  def create
  	@game = TicTacToe.new(tic_tac_toe_params)
  	if @game.save
  		flash[:success] = "Game started!"
  		respond_to do |format|
        format.html { render json: @game }
        format.json { render json: @game }
      end
  	else
  		redirect_to root_path
  	end
  end

  def show
  	@game = TicTacToe.find(params[:id])
    respond_to do |format|
      format.html { render json: @game }
      format.json { render json: @game }
    end
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
    if @game.board[move] == "0"
      prev_board[move] = "1"
      if empty_count(@game.board) >= 2
        @comp_move = @game.user_move(move)
        prev_board[@comp_move] = "2"
      end
    end
    @game.board = ""
    @game.save #it wouldn't recognize board changes without a clear and save
    @game.board = copy_board(prev_board)
    @game.winner_check
    if @game.update(board: copy_board(prev_board))
      respond_to do |format|
        format.html { render json: @game }
        format.json { render json: @game }
      end
    else
      redirect_to root_path
    end
  end


  private

  	def tic_tac_toe_params
  		params.require(:tic_tac_toe).permit(:board, :player_first, :id, :move, :turns_taken)
  	end

end
