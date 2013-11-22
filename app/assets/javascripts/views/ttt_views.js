$(function(){
	window.TicTacToeView = Backbone.View.extend({
		
		id: "game",
		className: "tic-tac-toe",
		
		events: {
			"click .grid-space" : "chooseGrid"
		},

		chooseGrid: function(){
			alert($(this).id);
		},

		template: _.template($("#tic-tac-toe-template").html()),

		render: function(){
			var attributes = this.model.toJSON();
			this.$el.html(this.template(attributes));
			return this;
		}
	});
});