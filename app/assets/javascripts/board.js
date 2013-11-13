$(document).ready(function(){
	var boardStr = $('#board-value').html();

	function printBoard(board){
		console.log('board', board);
		console.log('board length', board.length);
	}

	function paintBoard(board){
		//board="000120001";
		printBoard(board);
		addJSBoard(board);
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
	}

	printBoard(boardStr);
	paintBoard(boardStr);
	function addJSBoard(board){
		$('#js-board').html('js-board: ' + board);
	}
});