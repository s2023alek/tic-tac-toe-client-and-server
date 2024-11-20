// Project TicTacToe
package t_t.v {
	
	//{ ===== import
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import t_t.LOG;
	//} ===== END OF import
	
	
	/**
	 * abstract view component
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * 
	 */
	public class AVC {
		
		//{ ===== CONSTRUCTOR
		
		function AVC () {
		}
		//} ===== END OF CONSTRUCTOR
		
		public function setEnabled(a:Boolean):void {
			container.mouseEnabled = a; container.mouseChildren = a;
		}
		
		public function get_displayObject():Sprite {return container;}
		protected var container:Sprite;
		
		
		/**
		 * width
		 */
		protected var w:int;
		/**
		 * height
		 */
		protected var h:int;
		

		private static var consoleHM:Number=0;
		public static function get_consoleHM():Number {return consoleHM;}
		public static function set_consoleHM(a:Number):void {consoleHM = a;}
		
		public function runSelfTest():void {
			// override, super, and place your code here
		}		
		
		public function centerOnScreen(target:DisplayObject, ignoreObjectSize:Boolean = false):DisplayObject {
			if (!target) {return target;}
			if (ignoreObjectSize) {target.x = w/2;target.y = h/2;
			} else {target.x = w/2- target.width/2;target.y = h/2- target.height/2;}
			return target;
		}
		
		
		private var obligatoryEventSentInQueue_thisVCAccessible:Boolean;
		private var obligatoryEventDSentInQueue_thisVCAccessible:Object;
		
		//{ ======= events
		/**
		 * @param	listener function (target:VCScreenMain, eventType:String, details:Object=null):void;
		 */
		public function setListener(listener:Function):void {
			this.listener = listener;
			if (obligatoryEventSentInQueue_thisVCAccessible) {
				dispatchEvent(ID_E_INTERFACE_ACCESSIBLE, obligatoryEventDSentInQueue_thisVCAccessible);
				obligatoryEventSentInQueue_thisVCAccessible = false;obligatoryEventDSentInQueue_thisVCAccessible = null;
			}
		}
		
		protected function dispatchEvent(eventType:String, details:Object=null):void {
			if (listener == null) {
				if (eventType == ID_E_INTERFACE_ACCESSIBLE) { obligatoryEventSentInQueue_thisVCAccessible = true; obligatoryEventDSentInQueue_thisVCAccessible = details; }
				return;
			}
			listener(this, eventType, details);
		}
		private var listener:Function;
		//} ======= END OF events
		
		
		//{ ======= events id 
		/**
		 * all sub components are accessible, VCM can set listeners
		 */
		public static const ID_E_INTERFACE_ACCESSIBLE:String = '>ID_E_INTERFACE_ACCESSIBLE';
		//} ======= END OF events id
		
		
		
		/**
		* @param	c channel id(see LOGGER)
			0-"R"
			1-"DT"
			2-"DS"
			3-"V"
			4-"OP"
			5-"NET"
			6-"AG"
		* @param	m msg
		* @param	l level
			0-INFO
			1-WARNING
			2-ERROR
		*/
		private static function log(c:uint, m:String, l:uint=0):void {
			LOG(c,NAME+'>'+m,l);
		}
		
		
		
		public static const NAME:String = 'AVC';
		
	}
}