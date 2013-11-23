$(function(){
	window.GameOver = Backbone.View.extend({

		id: "game-over-el",

		template: _.template($('#game-over-template').html()),

		render: function(){
			console.log("in GameOver render");
			var attributes = this.model.toJSON().tic_tac_toe;
			console.log("attributes in GameOver", attributes);
			this.$el.hide();
			this.$el.html(this.template(attributes));
			this.$el.fadeIn(1000);
		}
	});
});