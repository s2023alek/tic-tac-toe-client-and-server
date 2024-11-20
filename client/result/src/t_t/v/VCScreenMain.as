// Project TicTacToe
package t_t.v {
	
	//{ ===== import
	import org.aswing.JTextField;
	import t_t.media.Text;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import t_t.LOG;
	import t_t.LOGGER;
	import flash.text.TextFormat;
	import org.aswing.ASColor;
	import org.aswing.border.EmptyBorder;
	import org.aswing.BorderLayout;
	import org.aswing.BoxLayout;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JPanel;
	import org.aswing.JScrollPane;
	import org.aswing.JTextArea;
	import org.aswing.SolidBackground;
	//} ===== END OF import
	
	
	
	/**
	 * main app window
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class VCScreenMain extends AVC {
		
		//{ ===== CONSTRUCTOR
		
		function VCScreenMain (w:uint, h:uint) {
			this.w  = w;
			this.h = h;
			prepareContainer();
			
		}
		
		
		//} ===== END OF CONSTRUCTOR
		

		//{ ======= ======= user access
		
		 
		public function addInterface(a:DisplayObject):DisplayObject {
			return interfaceLayer.addChild(a);
		}		
		
		public function removeInterface(a:DisplayObject):void {
			if (interfaceLayer.contains(a)) {interfaceLayer.removeChild(a);}
		}
		
		public function orderLayers():void {
			container.addChild(boardLayer);
			container.addChild(interfaceLayer);
		}
		
		
		public function repositionComponents():void {
			container.stage.addEventListener(Event.ENTER_FRAME, function (e:Event):void {
				//container.removeEventListener(e.type, arguments.callee);
				positionComponents();
			} );
		}
		
		public function positionComponents():void {
			if (!container || !container.stage) { return; }
			orderLayers();
		}
		
		 
		//} ======= ======= END OF user access
		
		/**
		 * dialog widows, other popups
		 */
		private var interfaceLayer:Sprite=new Sprite();
		private var boardLayer:Sprite=new Sprite();
		
		public function get_boardLayer():Sprite {return boardLayer;}
		public function get_interfaceLayer():Sprite {return interfaceLayer;}
		
		
		//{ ======= container
		private function prepareContainer():void {
			container = new Sprite();
			if (!container.stage) {container.addEventListener(Event.ADDED_TO_STAGE, el_addedToStage);} else {el_addedToStage();};
		}
		private function el_addedToStage(e:Event = null):void {
			container.removeEventListener(e.type, el_addedToStage);
			container.stage.addEventListener(Event.RESIZE, el_StageResize);
			
			el_StageResize();
		}
		
		private function el_StageResize(e:Event=null):void {
			//log(3, 'screen resolution changed:'+AppCfg.appScreenW+'x'+AppCfg.appScreenH);
			positionComponents();
			
			dispatchEvent(ID_E_STAGE_RESIZE, null);
		}
		
		

		//} ======= END OF container
		
		
		

		
		//{ ======= events id 
		public static const ID_E_STAGE_RESIZE:String = '>ID_E_STAGE_RESIZE';
		/**
		 * int
		 */
		public static const ID_E_B_ACTION:String = '>ID_E_B_ACTION';
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
		
		
		
		public static const NAME:String = 'VCMainScreen';
		
	}
}