class TicTacToe < ActiveRecord::Base

	def start(first_move)
		if first_move == 2 || 6 || 8
			first_move = 0
		end
		@game_over = false
		if player_first
			@player = "1"
			@comp = "2"
		else
			@comp = "1"
			@player = "2"
		end
		board[first_move] = @player
		if player_first
			game = { current_turn: 1, 1 => { player: 1, move: first_move, banned: [], board: board },
					 won: false }
			puts "game with player_first: #{game}"
		else
			game = { current_turn: 1, 1 => { player: 2, move: 10, banned: [], board: board },
					 won: false }
			puts "game with player_first false: #{game}"
		end

		@loop_had_loss = false

		move = ""
		move = take_turn(game)
		
		puts "START IS OVER"
		turn = compute_turn
		puts "turn: #{turn}"
		best = game[turn][:move]
		puts "FINAL best: #{best}"
		return best
	end

	def user_move(move)

		if player_first
			@player = "1"
			@comp = "2"
		else
			@comp = "1"
			@player = "2"
		end

		#game[:current_turn] += 1
		#new_board = board.dup
		puts "#{board}"
		board[move] = @player
		self.turns_taken += move.to_s
		puts "@player: #{@player}"
		turn = figure_turn
		puts "turn: #{turn}"
		game = { current_turn: turn, turn => { player: 1, move: move, banned: [], board: board },
					 won: false }
		puts "board: #{board}"
		#game[turn] = { player: @player, move: move, banned: [], 
		#							  board: board }

		#game[:current_turn] = turn

		my_move = ""
		my_move = take_turn(game)
		
		puts "USER MOVE IS OVER"
		#turn = compute_turn
		turn = figure_turn+1
		puts "turn: #{turn}"
		best = game[turn][:move]
		self.turns_taken += best.to_s
		puts "FINAL best: #{best}"
		board[best] = @comp
		return best
	end

	def figure_turn
		non_zeroes = 0
		for i in 0...board.length
			if board[i] != "0"
				non_zeroes += 1
			end
		end
		return non_zeroes
	end

	def compute_turn
		if player_first

		else
		end
		return 2
	end

	def take_turn(game)
		#pick a move (immediate winners first)
		move = pick_move(game)
		puts "move: #{move}"

		if move == nil
			puts "no move was found. move: #{move}"
			if !game[game[:current_turn]][:board].include?("0")
				puts "CAT'S GAME!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
				turn = figure_turn + 1
				puts "CAT'S GAME turn: #{turn}"
				best = game[turn][:move]
				game[:cats] = true
				#return best
			end
			#if no possible move(get_eligible_moves returns no moves) then call correct_prev_turn
			game[:current_turn] -= 1 #needs to go back an extra turn
			correct_prev_turn(game) unless game[:cats]
		else
			#if we win or tie, return this move
			if game[:won]
				#update board with winning move
				#game[game[:current_turn]][:move] = move
				#game[:current_turn] += 1

				puts "game won, returning winning move at index #{move}"
				puts "winning game was #{game}"
				turn = figure_turn + 1
				puts "turn: #{turn}"
				if game[turn]
					best = game[turn][:move]
				else
					best = move
				end
				puts "best: #{best}"



				#need to end game here
				#return best
			end

			new_board = game[game[:current_turn]][:board].dup
			#increment turn (unless this is a repeat turn)

			saved_bans = []
			if game[game[:current_turn]][:is_repeat]
				saved_bans = game[game[:current_turn]][:banned]
				game[:current_turn] -= 1
				game[game[:current_turn]][:is_repeat] = false
			end
			puts "current turn increased to #{game[:current_turn] + 1} from #{game[:current_turn]}"
			game[:current_turn] += 1

			#add move to hash
			new_board[move] = @comp
			game[game[:current_turn]] = { player: @comp, move: move, banned: saved_bans, 
										  board: new_board }


			puts "game hash updated: #{game}"

			#if picked a move, run gen_player_moves
			gen_player_moves(game) unless game[:won]
		end

		return move
	end

	def gen_player_moves(game)
		#check to see if any move wins game for player
		moves = empty_slots(current_board(game))
		puts "valid player moves: #{moves}"
		winner_arr = immediate_winner(game, moves, @player)

		new_board = game[game[:current_turn]][:board].dup
		game[:current_turn] += 1

		#new_board[winner_arr[1]] = @player
		game[game[:current_turn]] = { player: @player, move: 11, banned: [], 
									  board: new_board }
		#puts "game hash updated: #{game}"
		
		if winner_arr[0]
			puts "player has an immediate winner at index #{winner_arr[1]}"

			#new_board = game[game[:current_turn]][:board].dup
			#game[:current_turn] += 1
# 			#new_board[winner_arr[1]] = @player
#			#game[game[:current_turn]] = { player: @player, move: winner_arr[1], banned: [], 
#			#							  board: board = new_board }
			#puts "game hash updated: #{game}"

			#new_board = game[game[:current_turn]][:board].dup
			new_board[winner_arr[1]] = @player
			game[game[:current_turn]][:move] = winner_arr[1]
			game[game[:current_turn]][:board] = new_board
			#if any player move wins game, call correct_prev_turn
			@loop_had_loss = true
			puts "setting @loop_had_loss to #{@loop_had_loss}"
			correct_prev_turn(game)
		else
			#if no instant winner, for each possible player move, run take_turn w/ that as plyr turn
			#for loop runs thru moves, calls take_turn within loop with that move (and inc turn)
			#init_board = game[game[:current_turn]][:board].dup
			turn = game[:current_turn]
			first_run = true
			pre_moves = moves.dup
			#prev_turns_pre = []
			#TODO: CORRECT range when tn 1 dynamic
			#for k in 1...turn
			#	prev_turns_pre << game[k][:move]
			#end
			#puts "prev_turns_pre: #{prev_turns_pre}"
			finished = false
			puts "setting finished to false"
			for i in 0...moves.length
				puts "finished is #{finished}"
				if finished == true
					break
				end
				if @game_over 
					puts "that's game? above"
					break
				end
				#prev_turns = []
				#for k in 1...turn
				#	prev_turns << game[k][:move]
				#end
				#if prev_turns != prev_turns_pre
				#	puts "prev_turns != prev_turns_pre"
				#	puts "prev_turns_pre: #{prev_turns_pre}"
				#	puts "prev_turns: #{prev_turns}"
				#end
				#when in the for loop, go back to the turn that it was on the last time
				if game[:won] || game[:cats]
					#and reset the taken turns
					for j in turn+1..game[:current_turn]
						game[j] = {}
						puts "game[#{j}] should be removed"
					end
					puts "changing turn from #{game[:current_turn]} to #{turn}"
					game[:current_turn] = turn
				end

				game[:cats] = false
				#when coming from a comp won game, need to make turn the same as it was
				  #last time in the for loop, or will have 2 plyr tns in a row
				if game[:won]
					#game[:current_turn] -= 1
					#game[game[:current_turn]+1] = {}
					game[:won] = false
				end
				if game[game[:current_turn]] == {}
					#in for loop, but no turn was created before it. so we're doing old irrel loops.
					puts "BLANK TURN. Win condition?"
					break
				end
				puts "game[:current_turn]]: #{game[:current_turn]}"
				puts "game[game[:current_turn]][:move]: #{game[game[:current_turn]][:move]}"
				puts "game[game[:current_turn]][:board]: #{game[game[:current_turn]][:board]}"
				puts "game[game[:current_turn]][:board][moves[i]]: #{game[game[:current_turn]][:board][moves[i]]}"

				new_moves = empty_slots(current_board(game))
				puts "current_board(game): #{current_board(game)}"
				if moves != new_moves
					puts "moves != new_moves"
				end
				taken_moves = []
				for j in 1...turn
					#if game[j][:move]
					#	taken_moves << game[j][:move] 
					#else
						#taken_moves << game[turn][:board]
						taken_moves << self.turns_taken[j-1]
					#end
				end
				#for j in 0...game[game[turn]][:board].length
				#	if game[game[turn]][:board][j] != "0"
				#		taken_moves << j
				#	end
				#end
				if taken_moves.include?(moves[i])
					puts "ERROR: taken_moves (#{taken_moves}) includes moves[i] (#{moves[i]})"
					#break
					#game_over = true
					#break
					
					#puts "@loop_had_loss: #{@loop_had_loss}"
					#break if @loop_had_loss
					break
				end
				puts "pre_moves: #{pre_moves}"
				puts "moves: #{moves}"

				#init_board = game[game[:current_turn]][:board].dup
				#new_board = init_board.dup
				#new_board[moves[i]] = @player

				#undo prev iteration of loop if nec
				puts "first_run: #{first_run} for turn #{turn}. loop index #{i}"
				if i > 0
					undo_this_move = moves[i-1]
					unless first_run
						game[game[:current_turn]][:board][undo_this_move] = "0"
						puts "undid move at index #{undo_this_move} from last run of loop"
					end
					first_run = false
					#doesn't work when last
				end

				if(game[game[:current_turn]][:board][moves[i]] != "0")
					puts "index is #{i}"
					puts "moves[i]: #{moves[i]}"
					puts "turn: #{turn}"
					puts "game[game[:current_turn]][:board][moves[i]] is taken: #{game[game[:current_turn]][:board][moves[i]]}"
					puts "game[game[:current_turn]][:board]: #{game[game[:current_turn]][:board]}"
				end

				game[game[:current_turn]][:player] = @player
				game[game[:current_turn]][:move] = moves[i]
				game[game[:current_turn]][:board][moves[i]] = @player
				puts "game[:current_turn]]: #{game[:current_turn]}"
				puts "game[game[:current_turn]][:move]: #{game[game[:current_turn]][:move]}"
				puts "game[game[:current_turn]][:board][moves[i]]: #{game[game[:current_turn]][:board][moves[i]]}"
				puts "game[game[:current_turn]][:board]: #{game[game[:current_turn]][:board]}"

				puts "index #{i} in gen_player_moves LOOP, game updated: #{game}"

				non_zeroes = 0
				for j in 0...game[game[:current_turn]][:board].length
					if game[game[:current_turn]][:board][j] != "0"
						non_zeroes += 1
					end
				end
				if non_zeroes != turn
					puts "ALERT!! nonzeroes(#{non_zeroes}) doesn't equal turn (#{turn})"
					reconstr_board = "000000000"
					#TO DO: CORRECT LOOP to 1..turn when turn 1 is made dynamic
					#for j in 1..turn
					#	correct_move = game[j][:move]
					#	side = game[j][:player]
					#	reconstr_board[correct_move] = side.to_s
					#end
					puts "self.turns_taken: #{self.turns_taken}"
					#puts "self.turns_taken.length: #{self.turns_taken.length}"
					for j in 0...turn
						if self.turns_taken.length >0
							correct_move = self.turns_taken[j].to_i
							test_var = ""
						end
						test_var
						if player_first
							side = 1 if j % 2 == 1
							side = 2 if j % 2 == 0
						else
							side = 2 if j % 2 == 1
							side = 1 if j % 2 == 0
						end
						puts "side: #{side}"
						reconstr_board[correct_move] = side.to_s
					end
					puts "reconstr_board: #{reconstr_board}"
					corrected_board = reconstr_board.dup
					puts "changing #{game[game[:current_turn]][:board]} to #{corrected_board}"
					game[game[:current_turn]][:board] = corrected_board
				end

				#if player_first
				#	alt_game = { current_turn: 1, 1 => { player: 1, move: 10, banned: [], board: board },
				#			 won: false }
				#	puts "game with player_first: #{game}"
				#else
				#	game = { current_turn: 1, 1 => { player: 2, move: 10, banned: [], board: board },
				#			 won: false }
				#	alt_puts "game with player_first false: #{game}"
				#end
				if @game_over 
					puts "that's game? below"
					break
				end
				take_turn(game)
				#game[turn][:board][i] = "0" 
				#puts "undid move at index #{i} on turn #{turn} from last run of loop. board: #{game[turn][:board][i]}"
				puts "ending index #{i} of turn #{turn}"
			end
			@loop_had_loss = false
			puts "setting @loop_had_loss to #{@loop_had_loss}"
			finished = true
			puts "outside of for loop, setting finished to #{finished}"
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
		game[game[:current_turn]-1][:move] = "10"
		#decrement current turn
		game[:current_turn] -= 1
		game[game[:current_turn]][:is_repeat] = true
		
		#could delete last current turn here {}
		game[game[:current_turn]+1]= {}
		game[game[:current_turn]+2]= {}
		puts "game post-rollback #{game}"
		
		#call take_turn
		take_turn(game)

		#in no eligible move case, rollback 2 turns(to last comp turn)
	end

	def pick_move(game)
		moves = get_eligible_moves(game)
		move = ""
		puts "get_eligible_moves result: #{moves}"
		#puts "game[1]: #{game[1]}"
		puts "game[:current_turn]: #{game[:current_turn]}"
		puts "game[:board]: #{game[game[:current_turn]][:board]}"

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