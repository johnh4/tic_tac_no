$(function(){
	window.TicTacToeView = Backbone.View.extend({
		
		//id: "game",
		className: "tic-tac-toe",
		
		events: {
			"click #grid-1": "gridOne",
			"click #grid-2": "gridTwo",
			"click #grid-3": "gridThree",
			"click #grid-4": "gridFour",
			"click #grid-5": "gridFive",
			"click #grid-6": "gridSix",
			"click #grid-7": "gridSeven",
			"click #grid-8": "gridEight",
			"click #grid-9": "gridNine",
			"click #new"   : "restart"
		},

		restart: function(){
			console.log('in restart');
			this.nextGame = new TicTacToe({board: "000000002", turns_taken: "8", player_first: false});
			this.nextView = new TicTacToeView({ model: this.nextGame });
			this.nextView.render();
			$('#app').html(this.nextView.el);
		},

		initialize: function(){
			this.model.save();
			this.model.on('sync', this.setID, this);
			//console.log('id',this.model.get('id'));
			//this.model.sync();
			this.model.on('change', this.render, this);
			this.model.on('click', this.render, this);
		},

		template: _.template($("#tic-tac-toe-template").html()),

		render: function(){
			var boardStr = $('#board-value').html();
			var attributes = this.model.toJSON().tic_tac_toe;
			console.log("attributes in view render",attributes);
			this.$el.html(this.template(attributes));

			this.printBoard(boardStr);
			this.paintBoard(boardStr);

			return this;
		},

		setID: function(){
			console.log(this.model.get('id'));
			console.log('turns_taken', this.model.get('turns_taken'));
			this.render();
		},

		makeMove: function(move){
			var gameID = this.model.get('id');
			var promise = $.ajax({
				type: 'GET',
				dataType: 'json',
				contentType: 'application/json',
				url: '/tic_tac_toes/' + gameID + '/' + move
			});
			var self = this;
			promise.done(function(data){
				self.model.fetch();
			});
			return promise;
		},

		gridOne: function(){
			this.makeMove(0);
			
			console.log('id', $(this).prop('id'));
			console.log('gridOne clicked, moving at 0');
		},

		gridTwo: function(){
			this.makeMove(1);
			console.log('id', $(this).prop('id'));
		},
		gridThree: function(){
			this.makeMove(2);
			console.log('id', $(this).prop('id'));
		},
		gridFour: function(){
			this.makeMove(3);
			console.log('id', $(this).prop('id'));
		},
		gridFive: function(){
			this.makeMove(4);
			console.log('id', $(this).prop('id'));
		},
		gridSix: function(){
			this.makeMove(5);
			console.log('id', $(this).prop('id'));
		},
		gridSeven: function(){
			this.makeMove(6);
			console.log('id', $(this).prop('id'));
		},
		gridEight: function(){
			this.makeMove(7);
			console.log('id', $(this).prop('id'));
		},
		gridNine: function(){
			this.makeMove(8);
			console.log('id', $(this).prop('id'));
		},
		printBoard: function(board){
			console.log('board', board);
			console.log('board length', board.length);
		},

		paintBoard: function(board){
			//board="000120001";
			this.printBoard(board);
			this.addJSBoard(board);
			var gridIndex;
			for(i=0; i<board.length; i++){
				gridIndex = i + 1;
				if(board[i] == 1){
					$('#grid-'+gridIndex).addClass('player-move');
					console.log('player-move at ' + i);
				}
				if(board[i] == 2){
					$('#grid-'+gridIndex).addClass('comp-move');
					console.log('comp-move at ' + i);
				}
			}
		},

		addJSBoard: function(board){
			$('#js-board').html('js-board: ' + board);
		}
	});
});