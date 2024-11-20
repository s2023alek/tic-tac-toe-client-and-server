// Project TicTacToe
package t_t.d.dp {
	
	//{ ======= import
	import flash.utils.Dictionary;
	import t_t.d.app.i.IDUPlayer;
	import t_t.d.app.i.IDUPlayerAction;
	import t_t.d.app.i.IDUTTTGameSession;
	
	import t_t.LOG;
	import t_t.LOGGER;
	//} ======= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class DPDUTTTGameSession {
		
		/**
		 * try add player action data
		 * @param	session
		 * @param	player
		 * @param	action
		 * @return operation result (see static ID_UP*)
		 */
		public static function actionPlayer(session:IDUTTTGameSession, player:IDUPlayer, action:IDUPlayerAction):int {
			// TODO: 
		}
		
		public static const ID_UP_S_UPDATED:int = 0;
		public static const ID_UP_E_GAME_IS_OVER:int = 1;
		public static const ID_UP_E_NOT_CURRENT_PLAYER:int = 2;
		public static const ID_UP_E_BOARD_CELL_IS_NOT_EMPTY:int = 3;
		
		/**
		* @param	c channel id(see LOGGER)
			0-"R"
			1-"DT"
			2-"DS"
			3-"V"
			4-"OP"
			5-"NET"
			6-"AG"
			7-"AF"
		* @param	m msg
		* @param	l level
			0-INFO
			1-WARNING
			2-ERROR
		*/
		private static function log(c:uint, m:String, l:uint=0):void {
			LOG(LOGGER.C_OP,m,l);
		}
		
		
	}
}