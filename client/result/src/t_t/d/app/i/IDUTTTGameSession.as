// Project TicTacToe
package  t_t.d.app.i {
	
	//{ ======= import
	//} ======= END OF import
	
	
	/**
	 * unique id
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public interface IDUTTTGameSession extends IDUUID {

		/**
		 * WARNING: check whether user in list already in get_list_players()
		 */
		function addPlayer(a:IDUPlayer):void;
		function get_list_players():Vector.<IDUPlayer>;
		function get_board():IDUBoard;
		function get_currentPlayerId():String;
		function finish():void;
		function get_active():Boolean;
		
		function getPlayerById(id:String):IDUPlayer;
		function get_totalMarks(playerId:String):int;
		function get_winnerId():String;
	}
}