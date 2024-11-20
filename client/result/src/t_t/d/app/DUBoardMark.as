// Project TicTacToe
package  t_t.d.app {
	
	//{ ======= import
	import t_t.d.app.i.IDUBoardMark;
	//} ======= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class DUBoardMark extends DUAbstractUniversal implements IDUBoardMark {
		
		//{ ======= CONSTRUCTOR
		public function DUBoardMark (id:String, playerId:String, type:int, x:int, y:int) {
			super(id, pid, x, y, type);
		}
		//} ======= END OF CONSTRUCTOR
		
		public static const PLAYER_ID_YOU:String = 'y';
		public static const PLAYER_ID_AI:String = 'ai';
		
	}
}