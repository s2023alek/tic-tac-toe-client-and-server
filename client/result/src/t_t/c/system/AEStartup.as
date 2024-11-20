// Project TicTacToe
package t_t.c.system {
	
	//{ ======= import
	import t_t.Application;
	import t_t.c.ae.AE;
	//} ======= END OF import
	
	
	/**
	 * Abstract Agent Environment
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class AEStartup extends AE {
		
		//{ ======= CONSTRUCTOR
		
		function AEStartup (a:Application) {
			_a = a;
			super(NAME);
		}
		//} ======= END OF CONSTRUCTOR
		
		//public function set a(a:Application):void {_a = a;}
		public function get a():Application {return _a;}
		private var _a:Application;
		
		public static const NAME:String ='AEStartup';
		
	}
}