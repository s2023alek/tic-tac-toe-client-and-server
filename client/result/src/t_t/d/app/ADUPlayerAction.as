// Project TicTacToe
package  t_t.d.app {
	
	//{ ======= import
	import t_t.d.app.i.IDUPlayerAction;
	//} ======= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class ADUPlayerAction extends DUAbstractUniversal implements IDUPlayerAction {
		
		//{ ======= CONSTRUCTOR
		public function ADUPlayerAction (id:String, playerId:String) {
			super(id, playerId);
		}
		//} ======= END OF CONSTRUCTOR
		
		//{ ======= ID
		
		public static const ID_MARK:String = "PlayerActionID_MARK";
		public static const ID_QUIT_SESSION:String = "PlayerActionID_QUIT_SESSION";
		
		//} ======= END OF ID
		
		
	}
}