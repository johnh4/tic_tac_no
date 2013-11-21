module TicTacToesHelper
	def copy_board(to_copy)
		copy = ""
		for i in 0...to_copy.length
			copy += to_copy[i]
		end
		return copy
	end
end
