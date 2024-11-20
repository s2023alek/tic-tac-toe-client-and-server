package tk.jinanoimateydragoncat.utils.flow.agents {
	
	//{ ======= import
	import tk.jinanoimateydragoncat.utils.flow.agents.AbstractAgentEnvironment;
	import tk.jinanoimateydragoncat.utils.flow.data.IAM;
	//} ======= END OF import
	
	public class AbstractAgent {
		
		//{ ======= CONSTRUCTOR
		
		function AbstractAgent (name:String) {
			this.name = name;
		}
		//} ======= END OF CONSTRUCTOR
		
		//{ ======= input 
		
		public function listen(eventType:String, details:Object):void {
			// override and place your code here
		}
		
		public function autoSubscribeEvents(envName:String):Array {
			// override and place your code here
			return [];
		}
		//} ======= END OF input
		
		internal final function placed_(env:AbstractAgentEnvironment):void {
			envRef = env;
			if (enableAfterPlacement) { alive = true; }
			placed(env);
		}
		
		protected function placed(env:AbstractAgentEnvironment):void {
			// override and place your code here
		}
		
		public function get_envRef():AbstractAgentEnvironment {return envRef;}
		
		public function isAlive():Boolean {return alive;}
		public function setAlive(a:Boolean):void {alive=a;}
		
		protected var alive:Boolean;
		protected var enableAfterPlacement:Boolean=true;
		private var envRef:AbstractAgentEnvironment;
		/**
		 * agent name
		 */
		public function get_name():String {return name;}
		private var name:String;
	}
}