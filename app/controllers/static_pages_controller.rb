class StaticPagesController < ApplicationController
  def home
    @new_game = TicTacToe.create()
  end

end
