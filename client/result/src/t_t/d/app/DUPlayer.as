// Project TicTacToe
package  t_t.d.app {
	
	//{ ======= import
	import t_t.d.app.i.IDUPlayer;
	//} ======= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class DUPlayer extends DUAbstractUniversal implements IDUPlayer {
		
		//{ ======= CONSTRUCTOR
		public function DUPlayer (id:String, markTypeId:int, displayName:String=null) {
			super(id, null, 0, 0, markTypeId, 0, 0, displayName);
		}
		//} ======= END OF CONSTRUCTOR
		
	}
}