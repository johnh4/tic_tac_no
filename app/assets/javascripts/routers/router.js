$(function(){
	window.router = new (Backbone.Router.extend({

		routes: {
			"" : "home",
			//"tic_tac_toes/:id" : "show",
			"tic_tac_toes/:id/:move" : "userMove",
			"tic_tac_toes/new" : "newGame"
		},

		initialize: function(){
			//this.ticTacToes = new TicTacToes();
			this.firstGame = new TicTacToe();
			this.ticTacToeView = new TicTacToeView({ model: this.firstGame });
			this.ticTacToeView.render();
			
			console.log('router initialized');
		},

		home: function(){
			$('#app').html(this.ticTacToeView.el);
			//this.ticTacToes.fetch();

			//make a collection reset event that updates this or does something
			//this.firstGame = this.ticTacToes.get(1);
			//console.log("this.firstGame",this.firstGame);
		},

		show: function(id){
			console.log('in show action function');
			this.ticTacToe = this.ticTacToes.get(id)
			this.ticTacToeView = new TicTacToeView({ model: this.ticTacToe });
			$('#app').html(this.ticTacToeView.el);
		},

		newGame: function(){
			console.log('in newGame');
			this.nextGame = new TicTacToe();
			this.nextView = new TicTacToeView({ model: this.nextGame });
			this.nextView.render();
			$('#app').html(this.nextView.el);
		},

		userMove: function(id, move){

		},

		start: function(){
			Backbone.history.start();
		}
	}));
});