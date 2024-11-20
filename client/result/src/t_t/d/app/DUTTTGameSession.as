// Project TicTacToe
package  t_t.d.app {
	
	//{ ======= import
	import t_t.d.app.i.IDUBoard;
	import t_t.d.app.i.IDUBoardMark;
	import t_t.d.app.i.IDUPlayer;
	import t_t.d.app.i.IDUTTTGameSession;
	//} ======= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class DUTTTGameSession extends DUAbstractUniversal implements IDUTTTGameSession {
		
		//{ ======= CONSTRUCTOR
		public function DUTTTGameSession (id:String, board:IDUBoard) {
			super(id);
			b = board;
			active = true;
		}
		//} ======= END OF CONSTRUCTOR
		
		protected const l_p:Vector.<IDUPlayer> = new Vector.<IDUPlayer>;
		protected var b:IDUBoard;

		public function addPlayer(a:IDUPlayer):void {l_p.push(a);}
		
		public function get_list_players():Vector.<IDUPlayer> { return l_p.slice(); }
		public function get_board():IDUBoard { return b;}
		public function get_currentPlayerId():String { return pid; }

		public function set_currentPlayerId(a:String):void { pid = a; }
		
		
		private var active:Boolean;
		public function get_active():Boolean { return active; }
		public function finish():void { active = false; }
		
		
		public function getPlayerById(id:String):IDUPlayer {
			for each(var i:IDUPlayer in l_p) {
				if (i.get_id() == id) { return i; }
			}
			return null;
		}
		public function get_totalMarks(playerId:String):int {
			var a:int = 0;
			for each(var i:IDUBoardMark in b.get_listCellMarks()) {
				if (i.get_pid() == playerId) { a += 1; }
			}
			return a;
		}
		public function get_winnerId():String {
			return null;
		}
	}
}