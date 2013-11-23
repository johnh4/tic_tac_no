class TicTacToe < ActiveRecord::Base

	def user_move(move)
		@game_over = false
		@player = "1"
		@comp = "2"

		puts "#{board}"

		board[move] = @player
		self.turns_taken += move.to_s
		puts "@player: #{@player}"
		turn = figure_turn
		puts "turn: #{turn}"
		game = { current_turn: turn, turn => { player: 1, move: move, banned: [], board: board },
					 won: false }
		puts "board: #{board}"

		my_move = ""
		my_move = take_turn(game)
		
		puts "USER MOVE IS OVER"
		turn = figure_turn+1
		puts "turn: #{turn}"
		best = game[turn][:move]
		self.turns_taken += best.to_s
		puts "FINAL best: #{best}"
		board[best] = @comp
		return best
	end
	def set_turns_taken
		puts "self.turns_taken before being set: #{self.turns_taken}"
		turns = ""
		for i in 0...board.length
			if board[i] != "0"
				turns += i.to_s
			end
		end
		self.turns_taken = turns
		puts "self.turns_taken after being set: #{self.turns_taken}"
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

	def take_turn(game)
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
			end
			#if no possible move(get_eligible_moves returns no moves) then call correct_prev_turn
			game[:current_turn] -= 1 #needs to go back an extra turn
			correct_prev_turn(game) unless game[:cats]
		else
			if game[:won]
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
		moves = empty_slots(current_board(game))
		puts "valid player moves: #{moves}"
		#check to see if any move wins game for player
		winner_arr = immediate_winner(game, moves, @player)

		new_board = game[game[:current_turn]][:board].dup
		game[:current_turn] += 1

		game[game[:current_turn]] = { player: @player, move: 11, banned: [], 
									  board: new_board }
		
		if winner_arr[0]
			puts "player has an immediate winner at index #{winner_arr[1]}"

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
			turn = game[:current_turn]
			first_run = true
			pre_moves = moves.dup

			finished = false
			puts "setting finished to false"

			#record pre-loop board state
			pre_game = game.dup
			loop_game_arr = []
			moves_arr = []
			for i in 0...moves.length
				puts "starting index #{i} of turn #{turn}"
				puts "finished is #{finished}"
				if finished == true
					break
				end
				if @game_over 
					puts "that's game? above"
					break
				end

				#when in the for loop, go back to the turn that it was on the last time
				if game[:won] || game[:cats]
					#and reset the taken turns
					for j in turn+1..game[:current_turn]
						game[j] = {}
						puts "game[#{j}] should be removed"
					end
					puts "changing turn from #{game[:current_turn]} to #{turn}"
					#when coming from a comp won game, need to make turn the same as it was
					#last time in the for loop, or will have 2 plyr tns in a row
					game[:current_turn] = turn
				end

				game[:cats] = false
				if game[:won]
					game[:won] = false
				end
				if game[game[:current_turn]] == {}
					#in for loop, but no turn was created before it. so we're doing old irrel loops.
					puts "BLANK TURN. Win condition?"
					break
				end

				new_moves = empty_slots(current_board(game))
				puts "current_board(game): #{current_board(game)}"
				if moves != new_moves
					puts "moves != new_moves"
				end

				taken_moves = []

				for j in 1...game[:current_turn]
					if game[j]
						taken_moves << game[j][:move] #use the self.turns_taken one?
					else
						taken_moves << self.turns_taken[j-1]
					end
				end

				if taken_moves.include?(moves[i])
					puts "ERROR: taken_moves (#{taken_moves}) includes moves[i] (#{moves[i]})"
					puts "pre_moves: #{pre_moves}"
					puts "moves: #{moves}"
					puts "pre_game: #{pre_game}"					
					puts "game: #{game}"

					game_last_i = loop_game_arr[i-1]
					puts "game_last_i: #{game_last_i}"
					moves_last_i = moves_arr[i-1]
					puts "moves_last_i: #{moves_last_i}"
					moves_0 = moves_arr[0]
					puts "moves_0: #{moves_0}"

					#hard coded problem case solution
					if player_first == true
						if game[1][:move] == 5 
							game[2][:move] = 2
						elsif game[1][:move] == 7
							game[2][:move] = 6
						end
					end
					

					@game_over = true
					
					break
				end
				puts "pre_moves: #{pre_moves}"
				puts "moves: #{moves}"

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
				if non_zeroes != game[:current_turn]
					puts "ALERT!! nonzeroes(#{non_zeroes}) doesn't equal game[:current_turn] (#{game[:current_turn]})"
					reconstr_board = "000000000"

					puts "self.turns_taken: #{self.turns_taken}"
					puts "taken_moves before adding curr turn: #{taken_moves}"
					taken_moves << game[game[:current_turn]][:move]
					puts "taken_moves after adding curr turn: #{taken_moves}"
					for j in 0...game[:current_turn]
						if taken_moves.length >0
							correct_move = taken_moves[j].to_i
						end
						j_turn = j + 1
						if player_first
							side = 1 if j_turn % 2 == 1
							side = 2 if j_turn % 2 == 0
						else
							side = 2 if j_turn % 2 == 1
							side = 1 if j_turn % 2 == 0
						end
						puts "side: #{side}"
						reconstr_board[correct_move] = side.to_s
					end
					puts "reconstr_board: #{reconstr_board}"
					corrected_board = reconstr_board.dup
					puts "changing #{game[game[:current_turn]][:board]} to #{corrected_board}"
					game[game[:current_turn]][:board] = corrected_board
				end

				if @game_over 
					puts "that's game? below"
					break
				end
				i_game = game.dup
				loop_game_arr[i]= i_game
				i_move = moves.dup
				moves_arr[i] = i_move
				take_turn(game)
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

	def search_for_winner(side)
		winner = false
		if  board_has_winning_row(self.board, side) || board_has_winning_col(self.board, side) ||
			board_has_winning_diag(self.board, side)
			puts "winner found for player #{side}, in self.board #{self.board}"
			winner = true
		end
		return winner
	end

	def winner_check
		self.winner = @player if search_for_winner(@player)
		self.winner = @comp if search_for_winner(@comp)
		if self.winner == "0" && !self.board.include?("0")
			self.winner = "3" #cat's game
		end
		puts "self.board: #{self.board}"
		puts "self.winner: #{self.winner}"
		return self.winner
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