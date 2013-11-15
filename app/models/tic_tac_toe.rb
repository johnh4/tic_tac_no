class TicTacToe < ActiveRecord::Base

	def start
		if player_first
			@player = "1"
			@comp = "2"
		else
			@comp = "1"
			@player = "2"
		end
		if player_first
			game = { current_turn: 1, 1 => { player: 1, move: 10, banned: [], board: board },
					 won: false }
			puts "game with player_first: #{game}"
		else
			game = { current_turn: 1, 1 => { player: 2, move: 10, banned: [], board: board },
					 won: false }
			puts "game with player_first false: #{game}"
		end

		take_turn(game)
	end

	def take_turn(game)
		#pick a move (immediate winners first)
		move = pick_move(game)
		puts "move: #{move}"

		if move == nil
			puts "no move was found. move: #{move}"

			#if no possible move(get_eligible_moves returns no moves) then call correct_prev_turn
		else
			#if we win or tie, return this move
			if game[:won]
				puts "game won, returning winning move at index #{move}"
				return move
			end

			new_board = game[game[:current_turn]][:board].dup
			#increment turn
			puts "current turn increased to #{game[:current_turn] + 1} from #{game[:current_turn]}"
			game[:current_turn] += 1

			#add move to hash
			new_board[move] = @comp
			game[game[:current_turn]] = { player: @comp, move: move, banned: [], 
										  board: board = new_board }
			puts "game hash updated: #{game}"

			#if picked a move, run gen_player_moves
			gen_player_moves(game)
		end

		return move
	end

	def gen_player_moves(game)
		#check to see if any move wins game for player
		moves = empty_slots(current_board(game))
		puts "valid player moves: #{moves}"
		winner_arr = immediate_winner(game, moves, @player)
		if winner_arr[0]
			puts "player has an immediate winner at index #{winner_arr[1]}"

			new_board = game[game[:current_turn]][:board].dup
			game[:current_turn] += 1

			new_board[winner_arr[1]] = @player
			game[game[:current_turn]] = { player: @player, move: winner_arr[1], banned: [], 
										  board: board = new_board }
			puts "game hash updated: #{game}"

			#if any move wins game, call correct_prev_turn
			correct_prev_turn(game)
		else
			#if no instant winner, for each possible player move, run take_turn w/ that as plyr turn
			#for loop runs thru moves, calls take_turn within loop with that move (and inc turn)

		end

	end

	#called when plyr wins or no eligible move
	def correct_prev_turn(game)
		#goes to prev comp turn, adds that move to banned list and undoes it
		puts "rolling back to the previous turn"
		puts "game pre-rollback: #{game}"
		move = game[game[:current_turn]-1][:move]
		game[game[:current_turn]-1][:banned] << move
		game[game[:current_turn]-1][:board][move] = "0"
		#decrement current turn
		game[:current_turn] -= 1
		puts "game post-rollback #{game}"
		#call take_turn
		
	end

	def pick_move(game)
		moves = get_eligible_moves(game)
		move = ""
		puts "get_eligible_moves result: #{moves}"
		puts "game[1]: #{game[1]}"
		puts "game[:current_turn]: #{game[:current_turn]}"
		puts "game[:board]: #{game[1][:board]}"

		#check if immediate winner in moves
		winner_arr = immediate_winner(game, moves, @comp)
		if winner_arr[0]
			puts "immediate winner found, at index #{winner_arr[1]}"
			move = winner_arr[1]
			game[:won] = true
		else
			move = moves[0]
			puts "choosing #{move} from eligible moves #{moves}"
		end

		return move
	end

	def immediate_winner(game, eligible_moves, side)
		winner = ""
		result = [false, winner]
		eligible_moves.each do |move|
			trial_board = current_board(game).dup
			trial_board[move] = side
			if  board_has_winning_row(trial_board, side) || board_has_winning_col(trial_board, side) ||
				board_has_winning_diag(trial_board, side)
				puts "winner found for player #{side}, index #{move} in trial_board #{trial_board}"
				return result = [true, move]
			end
		end

		return result
	end

	def current_board(game)
		game[game[:current_turn]][:board]
	end

	def get_eligible_moves(game)
		moves = []
		#not taken
		current_board = game[game[:current_turn]][:board]
		blank = empty_slots(current_board)
		#banned
		banned = game[game[:current_turn]][:banned]
		puts "blank: #{blank}"
		puts "banned: #{banned}"
		moves = blank - banned
		return moves.uniq
	end

	def empty_slots(board)
		empty_locs = []
		for i in 0...board.length
			empty_locs << i if board[i] == "0"
		end
		return empty_locs
	end

	def board_has_winning_row(trial_board, side)
		has_winning_row = false
		if  ([side,trial_board[0],trial_board[1],trial_board[2]].uniq.length == 1) ||
		    ([side,trial_board[3],trial_board[4],trial_board[5]].uniq.length == 1) ||
		    ([side,trial_board[6],trial_board[7],trial_board[8]].uniq.length == 1)
			has_winning_row = true
		end
		return has_winning_row
	end

	def board_has_winning_col(trial_board, side)
		has_winning_col = false
		if 	([side,trial_board[0],trial_board[3],trial_board[6]].uniq.length == 1) ||
			([side,trial_board[1],trial_board[4],trial_board[7]].uniq.length == 1) ||
			([side,trial_board[2],trial_board[5],trial_board[8]].uniq.length == 1)
			has_winning_col = true
		end
		return has_winning_col
	end

	def board_has_winning_diag(trial_board, side)
		has_winning_diag = false
		if  ([side,trial_board[0],trial_board[4],trial_board[8]].uniq.length == 1) ||
			([side,trial_board[2],trial_board[4],trial_board[6]].uniq.length == 1)
			has_winning_diag = true
		end
		return has_winning_diag
	end

	def board_has_losing_row(complete_board, player)
		has_losing_row = false
		if  ([player,complete_board[0],complete_board[1],complete_board[2]].uniq.length == 1) ||
		    ([player,complete_board[3],complete_board[4],complete_board[5]].uniq.length == 1) ||
		    ([player,complete_board[6],complete_board[7],complete_board[8]].uniq.length == 1)
			has_losing_row = true
		end
		return has_losing_row
	end

	def board_has_losing_col(complete_board, player)
		has_losing_col = false
		if 	([player,complete_board[0],complete_board[3],complete_board[6]].uniq.length == 1) ||
			([player,complete_board[1],complete_board[4],complete_board[7]].uniq.length == 1) ||
			([player,complete_board[2],complete_board[5],complete_board[8]].uniq.length == 1)
			has_losing_col = true
		end
		return has_losing_col
	end

	def board_has_losing_diag(complete_board, player)
		has_losing_diag = false
		if ([player,complete_board[0],complete_board[4],complete_board[8]].uniq.length == 1) ||
			([player,complete_board[2],complete_board[4],complete_board[6]].uniq.length == 1)
			has_losing_diag = true
		end
		return has_losing_diag
	end
end

=begin
	def print_board
		puts board
	end

	def mark_comp_move(index)
		board[index] = "2"
	end

	def copy_board(to_copy)
		copy = ""
		for i in 0...to_copy.length
			copy << to_copy[i]
		end
		return copy
	end

	def try_moves
		losses = 0
		@trial_board = board.dup #copy_board(board)
		puts "@trial_board before empty guess, should equal board: #{@trial_board}"
		puts "board before insert in empty.each: #{board}"
		empty = empty_slots(board)

		best_move = nil
		losses_low = 100
		empty.each do |i|
			puts "board: #{board}"
			@trial_board[i] = "2"
			puts "@trial_board before calcs: #{@trial_board}"
			#puts "board after insert in empty.each: #{board}"
			comp_boards = possible_boards(@trial_board)
			losses = evaluate_boards(comp_boards)
			if losses < losses_low
				losses_low = losses
				best_move = i
				puts "new best_move: index #{best_move}"
			end
			puts "@trial_board after calcs: #{@trial_board}"
			@trial_board[i] = "0"
			#losses = 0
		end
		puts "BEST_MOVE: index #{best_move} with #{losses_low} losses."
		return best_move
	end

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
		uniq_boards = uniq_boards(all_boards)
		assembled_boards = assemble_boards(uniq_boards, empty)
		return assembled_boards
	end

	def all_boards(empty_str, moves_p1)
		all_boards = []
		start_str = reset_start_str(empty_str)
		puts "start_str: #{start_str}"
		moves_p2 = empty_str.length - moves_p1
		puts "moves_p2: #{moves_p2}"
		#

		#player 2's first turn
		moves_p2_left = moves_p2 - 1
		for i in 0...empty_str.length
			start_str[i] = "2" if moves_p2 > 0
			if moves_p2_left > 0
				next_turn(empty_str, start_str, all_boards, moves_p2_left)
			else
				all_boards << start_str.dup
			end
			start_str[i] = "1"
		end
		puts "all_boards: #{all_boards}"
		return all_boards
	end

	#player 2's subsequent turns
	def next_turn(empty_str, second_str, all_boards, moves_p2_left)
		moves_p2_left -= 1
		#puts "moves_p2_left: #{moves_p2_left}"
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

	def uniq_boards(all_boards)
		uniq_boards = all_boards.uniq
		puts "uniq_boards: #{uniq_boards}"
		return uniq_boards
	end

	def assemble_boards(uniq_boards, empty_arr)
		assembled_boards = []
		uniq_boards.each do |uniq_b|
			assemble_one = @trial_board.dup #copy_board(@trial_board)#@trial_board.dup #board.dup
			#puts "assemble_one: #{assemble_one}"
			for i in 0...board.length
				if @trial_board[i] == "0"
					#puts "assemble_one[i]: #{assemble_one[i]}"
					#puts "uniq_b[0]: #{uniq_b[0]}"
					assemble_one[i] = uniq_b[0]
					uniq_b = uniq_b[1..-1]
				end
			end
			assembled_boards << assemble_one
		end
		puts "assembled_boards: #{assembled_boards.uniq}"
		return assembled_boards
	end

	def evaluate_boards(complete_boards)
		loss_count = 0
		if player_first
			player = "1"
		else
			player = "2"
		end
		
		complete_boards.each do |complete_board|
			if (board_has_losing_row(complete_board, player) ||
				board_has_losing_col(complete_board, player) ||
				board_has_losing_diag(complete_board, player))
				loss_count += 1
			end
		end

		puts "loss_count: #{loss_count}"
		return loss_count
	end

	def board_has_losing_row(complete_board, player)
		has_losing_row = false
		if  ([player,complete_board[0],complete_board[1],complete_board[2]].uniq.length == 1) ||
		    ([player,complete_board[3],complete_board[4],complete_board[5]].uniq.length == 1) ||
		    ([player,complete_board[6],complete_board[7],complete_board[8]].uniq.length == 1)
			has_losing_row = true
		end
		return has_losing_row
	end

	def board_has_losing_col(complete_board, player)
		has_losing_col = false
		if 	([player,complete_board[0],complete_board[3],complete_board[6]].uniq.length == 1) ||
			([player,complete_board[1],complete_board[4],complete_board[7]].uniq.length == 1) ||
			([player,complete_board[2],complete_board[5],complete_board[8]].uniq.length == 1)
			has_losing_col = true
		end
		return has_losing_col
	end

	def board_has_losing_diag(complete_board, player)
		has_losing_diag = false
		if ([player,complete_board[0],complete_board[4],complete_board[8]].uniq.length == 1) ||
			([player,complete_board[2],complete_board[4],complete_board[6]].uniq.length == 1)
			has_losing_diag = true
		end
		return has_losing_diag
	end


	def reset_start_str(empty_str)
		start_str = ""
		empty_str.length.times { start_str << "1" }
		return start_str
	end
end
=end