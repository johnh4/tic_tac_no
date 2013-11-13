class TicTacToe < ActiveRecord::Base

	def print_board
		puts board
	end

	def mark_comp_move(index)
		board[index] = "2"
	end

	def try_moves
		trial_board = board
		empty = empty_slots(board)
		empty.each do |i|
			trial_board[i] = "2"
			#call possible_boards(trial_board)
			puts trial_board
			trial_board[i] = "0"
		end
	end

	#for each of my possible moves
	#calculate all possible boards

	def empty_slots(board)
		empty_locs = []
		for i in 0...board.length
			empty_locs << i if board[i] == "0"
		end
		return empty_locs
	end

	def possible_boards(board)
		empty = empty_slots(board)
		for i in 0...board.length
			if empty.include?(i)
				puts "index #{i} is empty" 
			end
		end
		#generate a string of 0's of same length as num of empty el's
		num_empty = empty.length
		empty_str = ""
		num_empty.times { empty_str << "0" }
		puts "empty_str: #{empty_str}"
		
		#calc number of moves for player 1 left
		odd = false
		if empty_str.length % 2 == 1 
			odd = true
		end
		puts odd
		if odd == false
			num_moves_p1 = empty_str.length/2 #if player_first
		else
			num_moves_p1 = (empty_str.length/2.0).ceil #if player_first
		end
		puts "num_moves_p1: #{num_moves_p1}"

		#result of all_boards
		all_boards = all_boards(empty_str, num_moves_p1)
		uniq_boards(all_boards)
	end

	def all_boards(empty_str, moves_p1)
		all_boards = []
		start_str = reset_start_str(empty_str)
		puts "start_str: #{start_str}"
		moves_p2 = empty_str.length - moves_p1
		puts "moves_p2: #{moves_p2}"
		#
=begin
		for i in 0...empty_str.length
			start_str[i] = "2"
			for j in 0...empty_str.length
				if i != j
					start_str[j] = "2"
					all_boards << start_str.dup
					start_str[j] = "1"
				end
			end
			start_str[i] = "1"
		end
=end
		#player 2's first turn
		moves_p2_left = moves_p2 - 1
		for i in 0...empty_str.length
			start_str[i] = "2"
			next_turn(empty_str, start_str, all_boards, moves_p2_left)
			start_str[i] = "1"

		end
		puts "all_boards: #{all_boards}"
		return all_boards
	end

	#player 2's subsequent turns
	def next_turn(empty_str, second_str, all_boards, moves_p2_left)
		moves_p2_left -= 1
		puts "moves_p2_left: #{moves_p2_left}"
		for i in 0...empty_str.length
			if second_str[i] != "2"
				second_str[i] = "2"
				if moves_p2_left == 0
					all_boards << second_str.dup 
				else
					next_turn(empty_str, second_str, all_boards, moves_p2_left)
				end
				second_str[i] = "1"
			end
		end
	end

	def third_turn(third_str)

	end

	def uniq_boards(all_boards)
		uniq_boards = all_boards.uniq
		puts "uniq_boards: #{uniq_boards}"
		return uniq_boards
	end

	def reset_start_str(empty_str)
		start_str = "" 
		empty_str.length.times { start_str << "1" }
		return start_str
	end
end
