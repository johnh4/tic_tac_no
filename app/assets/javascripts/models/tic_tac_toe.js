$(function(){
	window.TicTacToe = Backbone.Model.extend({
		urlRoot: "/tic_tac_toes",

		toJSON: function() {
		  return { tic_tac_toe: _.clone( this.attributes ) }
		},

		defaults: {
			"board": "000000000",
			"player_first": true,
			"turns_taken": "",
			"winner": "0"
		}
	});
});