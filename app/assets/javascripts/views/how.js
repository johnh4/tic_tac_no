$(function(){
	window.How = Backbone.View.extend({

		id: "how-el",

		template: _.template($('#how-template').html()),

		render: function(){
			console.log('in How render');
			//this.$el.hide();
			this.$el.html(this.template());
			//this.$el.fadeIn(1000);
		}
	});
});