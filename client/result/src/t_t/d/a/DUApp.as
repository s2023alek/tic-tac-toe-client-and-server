// Project TicTacToe
package t_t.d.a {
	
	//{ ======= import
	import t_t.LOG;
	import t_t.d.app.i.IDUTTTGameSession;
	//} ======= END OF import
	
	
	/**
	 * contains main application data storeroom
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class DUApp {
		
		//{ ======= CONSTRUCTOR
		
		public function DUApp () {
		}
		//} ======= END OF CONSTRUCTOR
		
		private var gameSession:IDUTTTGameSession;
		
		
		public function get_gameSession():IDUTTTGameSession {return gameSession;}
		public function set_gameSession(a:IDUTTTGameSession):void {gameSession = a;}
		
	}
}