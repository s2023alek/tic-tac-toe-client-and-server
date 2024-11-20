package tk.jinanoimateydragoncat.utils.flow.agents {
	
	//{ ======= import
	import flash.utils.Dictionary;
	import tk.jinanoimateydragoncat.utils.flow.agents.AbstractAgent;
	import t_t.LOG;
	import tk.jinanoimateydragoncat.utils.flow.data.IAM;
	//} ======= END OF import
	
	
	/**
	 * all alive agents receiving non-service(user) events after <i>set_notifyAll(true);</i>
	 * @author Jinanoimatey Dragoncat
	 * @version 1.0.0
	 * 
	 */
	public class AbstractAgentEnvironment extends AbstractAgent {
		
		//{ ======= CONSTRUCTOR
		
		function AbstractAgentEnvironment (name:String) {
			super((name==null)?NAME:name);
			em = [];
		}
		public static const NAME:String = 'AbstractAgentEnvironment';
		//} ======= END OF CONSTRUCTOR
		
		
		//{ ======= public
		
		/**
		 * @param	eventType see list below
		 * @param	detais
		 */
		public override function listen(eventType:String, details:Object):void {
			if (logMessages && list_doNotLog_eventType.indexOf(eventType)==-1) {
				log(eventType);
			}
			if (notifyAll) {
				en_notifyAliveAgents(eventType, details);
			} else {
				en_notifyAliveInterestedOnlyAgents(eventType, details);
			}
		}
		
		public function placeAgent(a:AbstractAgent):void {
			if (agents.indexOf(a)>-1) {return;}
			agents.push(a);
			//subscribe
			var b:Array = a.autoSubscribeEvents(get_name());
			for each(var i:String in b) { subscribe(a, i); }
			// inform agent about placement
			a.placed_(this);
		}
		
		/**
		 * set alive to false, rmeove from list, remove subscription to autoSubscribeEvents list
		 * @param	a
		 */
		public function removeAgent(a:AbstractAgent):void {
			a.setAlive(false);
			if (agents.indexOf(a)==-1) {return;}
			agents.splice(agents.indexOf(a), 1);
			//
			var b:Array = a.autoSubscribeEvents(get_name());
			for each(var i:String in b) {unsubscribe(a, i);}
		}
		
		/**
		 * force dispatch event to all agents istead of interested(condition change event will remain unaffected)
		 */
		public function get_notifyAll():Boolean {return notifyAll;}
		public function set_notifyAll(a:Boolean):void {notifyAll = a;}
		
		
		/**
		 * to event
		 * @return true-added; false-already subscribed to event
		 */
		public function subscribe(target:AbstractAgent, eventType:String):Boolean {
			var a:Array = em[eventType];
			if (a==null) {
				a = [];
				em[eventType] = a;
			}
			
			for each(var i:AbstractAgent in a) {
				if (i==target) {
					return false;
				}
			}
			
			a.push(target);
			
			return true;
		}
		
		/**
		 * to event
		 * @return true-removed; false-was not subscribed to event
		 */
		public function unsubscribe(target:AbstractAgent, eventType:String):Boolean {
			var a:Array= em[eventType];
			if (a==null) {
				return false;
			}
			
			for each(var i:AbstractAgent in a) {
				if (i==target) {
					a.splice(a.indexOf(target), 1);
					if (a.length==0) {//no subscribers left
						delete em[eventType];
					}
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * from all events
		 */
		// NOTE: not tested!
		public function unsubscribeALL(target:AbstractAgent):void {
			for each(var i:String in em) {//eventType
				var a:Array = em[i];//agents list for eventType
				if (!a) {continue;}//list is invalid or not exist
				for each(var ia:AbstractAgent in a) {
					if (ia==target) {
						a.splice(a.indexOf(target), 1);
						if (a.length==0) {//no subscribers left
							delete em[i];
							break;//list deleted. goto next
						}
					}
				}
			}
		}
		
		public function doLogMessage(eventType:String):void {
			var l_:uint = list_doNotLog_eventType.length;
			for (var j:int = 0; j += 1; j<l_) {
				if (list_doNotLog_eventType[j] == eventType) {
					list_doNotLog_eventType.splice(j, 1);
				}
			}
		}
		
		public function doNotLogMessage(eventType:String):void {
			var l_:uint = list_doNotLog_eventType.length;
			for (var j:int = 0; j += 1; j<l_) {
				if (list_doNotLog_eventType[j] == eventType) {return;}}
			list_doNotLog_eventType.push(eventType);
		}
		
		private var list_doNotLog_eventType:Array=[];
		//} ======= END OF public
		
		
		private var agents:Array = [];
		private var notifyAll:Boolean;
		
		
		//{ ======= engineering events
		private function en_notifyAliveAgents(eventType:String, details:Object):void {
			for each(var i:AbstractAgent in agents) {
				if (i.isAlive()) {
					i.listen(eventType, details);
				}
			}
		}
		
		private function en_notifyAliveInterestedOnlyAgents(eventType:String, details:Object):void {
			var a:Array = em[eventType];
			if (a==null) {return;}//no subscribers
			
			for each(var i:AbstractAgent in a) {
				if (i.isAlive()) {
					//try {// 20.09.2012
						i.listen(eventType, details);
					//} catch(e:Error) {
						//log(6, 'runtime error:'+e.getStackTrace(),2);
					//}
				}
			}
		}
		
		
		/**
		 * events map
		 */
		private var em:Array;
		
		//} ======= END OF engineering events
		
		
		
		
		//{ ======= logging new
		public var logMessages:Boolean;
		
		public static const LOGGER_LEVEL_INFO:int=0;
		public static const LOGGER_LEVEL_WARNING:int=1;
		public static const LOGGER_LEVEL_ERROR:int=2;
		/**
		* @param	m msg
		* @param	l level 0-info, 1-warning, 2-error
		*/
		protected final function log(m:String, l:int=0):void {
			if (i==null) {return;}
			i(get_name().concat('>').concat(m), l);
		}
		
		/**
		 * function (m:String, l:uint):void;//message, level
		 */
		public function setL(a:Function):void {i=a;}
		/**
		 * logger method ref
		 */
		private var i:Function;
		//} ======= END OF logging new
		
	}
}