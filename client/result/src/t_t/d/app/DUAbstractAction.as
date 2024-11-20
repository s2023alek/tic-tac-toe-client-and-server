// Project TicTacToe
package  t_t.d.app {
	
	//{ ======= import
	//} ======= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class DUAbstractAction implements IDUAction {
		
		//{ ======= CONSTRUCTOR
		public function DUAbstractAction (id:String, c:DUCondition) {
			this.id = id;
			this.c = c;
		}
		//} ======= END OF CONSTRUCTOR
		
		public function get_displayTextId():String {return id;}
		public function get_id():String {return id;}
		public function get_condition():DUCondition { return c; }
		
		
		private var id:String;
		private var c:DUCondition;
		
	}
}