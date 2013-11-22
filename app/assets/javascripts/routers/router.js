$(function(){
	window.router = new (Backbone.Router.extend({

		routes: {
			"" : "home",
			"tic_tac_toes/:id" : "show",
			"tic_tac_toes/:id/:move" : "userMove"
		},

		initialize: function(){
			//this.ticTacToes = new TicTacToes();
			this.firstGame = new TicTacToe();
			this.ticTacToeView = new TicTacToeView({ model: this.firstGame });
			this.ticTacToeView.render();
			
			//var self = this;
			//this.ticTacToes.fetch({
		    //    success: function(coll, resp) {
		    //      console.log("coll",coll);
		    //      console.log("coll.first()",coll.first());
		    //      console.log("coll.last()", coll.last());
		    //      console.log("this.ticTacToes.at(1)", self.ticTacToes.at(1));
		    //      self.firstGame = self.ticTacToes.get(1);
		    //      console.log("self.firstGame",self.firstGame);
		    //    }
			//});
			
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
			this.ticTacToe = this.ticTacToes.get(id)
			this.ticTacToeView = new TicTacToeView({ model: this.ticTacToe });
			$('#app').html(this.ticTacToeView.el);
		},

		userMove: function(id, move){

		},

		start: function(){
			Backbone.history.start();
		}
	}));
});