module TicTacToesHelper
	def copy_board(to_copy)
		copy = ""
		for i in 0...to_copy.length
			copy += to_copy[i]
		end
		return copy
	end

	def empty_count(board)
		empty_locs = []
		for i in 0...board.length
			empty_locs << i if board[i] == "0"
		end
		return empty_locs.length
	end
end
