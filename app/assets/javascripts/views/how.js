$(function(){
	window.How = Backbone.View.extend({

		id: "how-el",

		template: _.template($('#how-template').html()),

		render: function(){
			console.log('in How render');
			this.$el.html(this.template());
		}
	});
});