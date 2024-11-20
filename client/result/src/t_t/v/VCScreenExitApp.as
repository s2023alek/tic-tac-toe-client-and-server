// Project TicTacToe
package t_t.v {
	
	//{ ===== import
	import org.aswing.BorderLayout;
	import org.aswing.BoxLayout;
	import org.aswing.Insets;
	import org.aswing.JButton;
	import org.aswing.JPanel;
	import org.aswing.JPopup;
	import org.aswing.border.EmptyBorder;
	import t_t.APP;
	import t_t.media.Text;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import t_t.LOG;
	import t_t.LOGGER;

	//} ===== END OF import
	
	
	
	/**
	 * main app window
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class VCScreenExitApp extends AVC {
		
		//{ ===== CONSTRUCTOR
		
		function VCScreenExitApp (w:uint, h:uint) {
			this.w = w;
			this.h = h;
			prepareContainer();
			
			dispatchEvent(AVC.ID_E_INTERFACE_ACCESSIBLE);
		}
		
		private function addSomeInterface():void {
			vc = new JPopup(container);
			vc.setLayout(new BorderLayout());
			vc.show();
			
			
			actionsList = new JPanel(new BoxLayout(BoxLayout.Y_AXIS, 10));
			vc.append(actionsList, BorderLayout.CENTER);
			
			runSelfTest();
			
			var ssss:Sprite = new Sprite;
			ssss.graphics.beginFill(0xff00ff, 1);
			ssss.graphics.drawRect(5, 5, 222, 222);
			ssss.graphics.endFill();
			//actionsList.addChild(ssss);
			
			vc.pack();
			
			
		}
		
		override public function runSelfTest():void {
			addActionButton(0, APP.lText().get_TEXT(Text.ID_TEXT_EXIT_CONFIRM));
			addActionButton(1, APP.lText().get_TEXT(Text.ID_TEXT_EXIT_CANCEL));
			super.runSelfTest();
		}
		
		private function el_actionButtons(targetID:int):void {
			dispatchEvent(ID_E_B_ACTION, [ID_E_B_Y, ID_E_B_N][targetID]);
		}		
		
		//} ===== END OF CONSTRUCTOR
		

		//{ ======= ======= user access
		public function removeActionButton(id:int):void {
			for each(var i:VCSimpleButton in actionButtons) {
				if (i.get_id() == id) {
					i.destroy();
					i.getParent().remove(i);
					actionButtons.splice(actionButtons.indexOf(i), 1);
					vc.repaintAndRevalidate();
					break;
				}
			}	
		}
		
		public function addActionButton(id:int, label:String):void {
			var ab0:VCSimpleButton = new VCSimpleButton(id, el_actionButtons, label);
			actionsList.append(ab0);
			actionButtons.push(ab0);
			vc.repaintAndRevalidate();
		}
	
		
		public function orderLayers():void {
			container.addChild(vc);
		}
		 
		public function repositionComponents():void {
			container.stage.addEventListener(Event.ENTER_FRAME, function (e:Event):void {
				container.removeEventListener(e.type, arguments.callee);
				positionComponents();
			} );
		}
		
		public function positionComponents():void {
			if (!container || !container.stage) {return; } 
			orderLayers();
		}
		
		
		//} ======= ======= END OF user access
		
		private var actionButtons:Vector.<VCSimpleButton> = new Vector.<VCSimpleButton>;
		
		private var vc:JPopup;
		private var actionsList:JPanel;
		
		//{ ======= container
		private function prepareContainer():void {
			container = new Sprite();
			if (!container.stage) {container.addEventListener(Event.ADDED_TO_STAGE, el_addedToStage);} else {el_addedToStage();};
		}
		private function el_addedToStage(e:Event = null):void {
			//container.removeEventListener(e.type, el_addedToStage);
			if (addedToStageAtleastOnce) { el_StageResize(); return; }
			
			addedToStageAtleastOnce = true;
			container.stage.addEventListener(Event.RESIZE, el_StageResize);
			addSomeInterface();
			el_StageResize();
		}
		private var addedToStageAtleastOnce:Boolean;
		
		

		private function el_StageResize(e:Event = null):void { if (!vc.stage) { return;}
			//log(3, 'screen resolution changed:'+AppCfg.appScreenW+'x'+AppCfg.appScreenH);
			positionComponents();
			resizeVC();
		}


		private function resizeVC():void {
			w = vc.stage.stageWidth;
			h = vc.stage.stageHeight *(1-AVC.get_consoleHM());
			vc.setSizeWH(w, h);
			vc.setBorder(new EmptyBorder(null, new Insets(h / 20, w / 20, h / 20, w / 20)));
		}
		
		//} ======= END OF container
		
		
		//{ ======= events id 
		public static const ID_E_B_Y:String = '>ID_E_B_Y';
		public static const ID_E_B_N:String = '>ID_E_B_N';
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
		
		
		
		public static const NAME:String = 'VCScreenExitApp';
		
	}
}