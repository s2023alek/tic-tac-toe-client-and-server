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
	public class VCGameUIMain extends AVC {
		
		//{ ===== CONSTRUCTOR
		
		function VCGameUIMain (w:uint, h:uint) {
			this.w = w;
			this.h = h;
			prepareContainer();
			
			dispatchEvent(AVC.ID_E_INTERFACE_ACCESSIBLE);
		}
		
		private function addSomeInterface():void {
			vc = new JPopup(container);
			vc.setLayout(new BorderLayout());
			vc.show();
			
			
			
			actionsList = new JPanel(new BoxLayout(BoxLayout.X_AXIS, 20));
			vc.append(actionsList, BorderLayout.NORTH);
			
			runSelfTest();
			
		}
		
		override public function runSelfTest():void {
			addActionButton(0, APP.lText().get_TEXT(Text.ID_TEXT_PAUSE_EXIT));
			resetButton = addActionButton(1, APP.lText().get_TEXT(Text.ID_TEXT_RESTART));
			resetButton.setVisible(resetButtonEnabled);
			
			super.runSelfTest();
		}
		
		private function el_actionButtons(targetID:int):void {
			dispatchEvent(ID_E_B_ACTION, [ID_E_B_PAUSE_EXIT, ID_E_B_RESTART][targetID]);
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
		
		public function setResetButtonVisibility(visible:Boolean):void {
			/*
			for each(var i:VCSimpleButton in actionButtons) {
				if (i.get_id() == 1) {
					i.setVisible(visible);
					vc.repaintAndRevalidate();
					break;
				}
			}*/
			resetButtonEnabled = visible;
			if (resetButton) {
				resetButton.setVisible(visible);
			}
		}
		private var resetButtonEnabled:Boolean;
		private var resetButton:VCSimpleButton;
		
		public function addActionButton(id:int, label:String):VCSimpleButton {
			var ab0:VCSimpleButton = new VCSimpleButton(id, el_actionButtons, label);
			actionsList.append(ab0);
			actionButtons.push(ab0);
			vc.repaintAndRevalidate();
			return ab0;
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
			var appH:int = vc.stage.stageHeight *(1-AVC.get_consoleHM());
			vc.setSizeWH(w, h);
			vc.setY(appH - h);
			vc.setBorder(new EmptyBorder(null, new Insets(h / 30, w / 30, h / 30, w / 30)));
		}
		
		//} ======= END OF container
		
		
		//{ ======= events id 
		public static const ID_E_B_PAUSE_EXIT:String = '>ID_E_B_PAUSE_EXIT';
		public static const ID_E_B_RESTART:String = '>ID_E_B_RESTART';
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
		
		
		
		public static const NAME:String = 'VCGameUIMain';
		
	}
}