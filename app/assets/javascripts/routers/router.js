$(function(){
	window.router = new (Backbone.Router.extend({

		routes: {
			"" : "home",
			"tic_tac_toes/new" : "newGame"
		},

		initialize: function(){
			this.firstGame = new TicTacToe();
			this.ticTacToeView = new TicTacToeView({ model: this.firstGame });
			this.ticTacToeView.render();
			
			console.log('router initialized');
		},

		home: function(){
			$('#app').html(this.ticTacToeView.el);
		},
		
		start: function(){
			Backbone.history.start();
		}
	}));
});