$(function(){
	window.TicTacToes = Backbone.Collection.extend({
		model: TicTacToe,
		url: '/tic_tac_toes'
	});
});