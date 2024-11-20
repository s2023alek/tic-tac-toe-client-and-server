// Project TicTacToe
package t_t.v {
	
	//{ ===== import
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.aswing.ASFont;
	import org.aswing.BorderLayout;
	import org.aswing.BoxLayout;
	import org.aswing.Insets;
	import org.aswing.JButton;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JPopup;
	import org.aswing.JTextField;
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
	public class VCScreenStats extends AVC {
		
		//{ ===== CONSTRUCTOR
		
		function VCScreenStats (w:uint, h:uint) {
			this.w = w;
			this.h = h;
			prepareContainer();
			
			//prep view
			dtWinner = new JTextField('');
			dtWinner.setEditable(false);dtWinner.setEnabled(false);

			
			dispatchEvent(AVC.ID_E_INTERFACE_ACCESSIBLE);
		}
		
		private function addSomeInterface():void {
			vc = new JPopup(container);
			vc.setLayout(new BorderLayout());
			vc.show();
			
			actionsList = new JPanel(new BorderLayout(10, 10));
			
			actionsList.append(dtWinner, BorderLayout.CENTER);
			
			
			var ab0:VCSimpleButton = new VCSimpleButton(0, el_actionButtons, APP.lText().get_TEXT(Text.ID_TEXT_EXIT));
			actionsList.append(ab0, BorderLayout.SOUTH);actionButtons.push(ab0);
			vc.repaintAndRevalidate();

			
			vc.append(actionsList, BorderLayout.CENTER);
						
			vc.pack();
			
			//test
			//setText(!true, 444);
			
		}
		
		private function el_actionButtons(targetID:int):void {
			dispatchEvent(ID_E_B_ACTION, [ID_E_B_BACK][targetID]);
		}		
		
		//} ===== END OF CONSTRUCTOR
		

		//{ ======= ======= user access
	
		public function setText(userWon:int, numMarks:int):void {
			if (numMarks == -1) {// online mode
				
				if (userWon == -1) {//ничья
					dtWinner.setText(APP.lText().get_TEXT(Text.ID_TEXT_THE_BOARD_IS_FULL));
				} else {
					dtWinner.setText(APP.lText().get_TEXT_4STATS_ONLINE_MODE(userWon));	
				}
				
			} else {
				dtWinner.setText(APP.lText().get_TEXT_4STATS(userWon, numMarks));
			}
			
			dtWinner.setTextFormat(new TextFormat('Tahoma', 24, null, true, null, null, null, null, TextFormatAlign.CENTER));
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
		private var dtWinner:JTextField;
		
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
		public static const ID_E_B_BACK:String = '>ID_E_B_BACK';
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
		
		
		
		public static const NAME:String = 'VCScreenStats';
		
	}
}