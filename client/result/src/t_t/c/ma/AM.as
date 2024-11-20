// Project TicTacToe
package t_t.c.ma {
	
	//{ ======= import
	import t_t.Application;
	import t_t.c.ae.AEApp;
	import t_t.d.a.DUApp;
	import tk.jinanoimateydragoncat.utils.flow.agents.AbstractAgent;
	import t_t.LOG;
	import tk.jinanoimateydragoncat.utils.flow.agents.AbstractAgentEnvironment;
	//} ======= END OF import
	
	
	/**
	 * Abstract Manager
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class AM extends AbstractAgent {
		
		//{ ======= CONSTRUCTOR
		
		function AM (name:String) {
			super(name);
		}
		//} ======= END OF CONSTRUCTOR
		
		
		public function get ad():DUApp { return a.get_appData(); }
		
		public function get e():AbstractAgentEnvironment {return get_envRef();}
		
		public function set a(a:Application):void {if (_a) { return;}_a = a;}
		public function get a():Application {
			if (_a == null) {_a = AEApp(get_envRef()).get_appRef();}
			return _a;
		}
		private var _a:Application;
		
	}
}