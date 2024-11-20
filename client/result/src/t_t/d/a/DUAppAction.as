// Project TicTacToe
package t_t.d.a {
	
	//{ ======= import
	import t_t.LOG;
	//} ======= END OF import
	
	
	/**
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class DUAppAction {
		
		//{ ======= CONSTRUCTOR
		
		public function DUAppAction (id:int, bTitle:String, itTitle:String) {
			this.id = id;
			this.bTitle = bTitle;
			this.itTitle = itTitle;
		}
		//} ======= END OF CONSTRUCTOR
		
		
		public function get_id():int {return id;}
		public function get_bTitle():String {return bTitle;}
		public function get_itTitle():String {return itTitle;}
		
		private var id:int;
		private var bTitle:String;
		private var itTitle:String;
		
		
	}
}