// Project TicTacToe
package t_t.v {
	
	//{ ===== import
	import flash.geom.Point;
	import org.aswing.BorderLayout;
	import org.aswing.BoxLayout;
	import org.aswing.Insets;
	import org.aswing.JButton;
	import org.aswing.JPanel;
	import org.aswing.JPopup;
	import org.aswing.JScrollPane;
	import org.aswing.JTextArea;
	import org.aswing.JTextField;
	import org.aswing.border.EmptyBorder;
	import t_t.APP;
	import t_t.d.app.DUMarkType;
	import t_t.lib.Library;
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
	public class VCChat extends AVC {
		
		//{ ===== CONSTRUCTOR
		
		function VCChat (reduceHeighWebVersion:int, width:int) {
			this.reduceHeighWebVersion = reduceHeighWebVersion;
			this.width = width;
			prepareContainer();
			//addOutLine(APP.lText().get_TEXT(Text.ID_TEXT_CHAT_TITLE));
			
			dispatchEvent(AVC.ID_E_INTERFACE_ACCESSIBLE);
		}
		
		//} ===== END OF CONSTRUCTOR
		
		
		//{ ===== ===== user access
		
		public function addOutLine(s:String):void {
			dt.setHtmlText("<b>[" + msgNumber + "] </b>" + s + "<br>" + dt.getHtmlText());
			msgNumber += 1;
		}
		private var msgNumber:uint = 1;
		
		public function getInputText():String {
			var s:String = it.getText();
			it.setText("");
			return s;
		}
		public function orderLayers():void {
			container.addChild(vc);
		}
		 
		public function repositionComponents():void {
			container.stage.addEventListener(Event.ENTER_FRAME, function (e:Event):void {//TODO: bug below listener not removed
				container.removeEventListener(e.type, arguments.callee);
				positionComponents();
			} );
		}
		
		public function positionComponents():void {
			if (!container || !container.stage) {return; } 
			orderLayers();
		}
		
		
		//} ======= ======= END OF user access
		
		
		private function addSomeInterface():void {
			//vc = new JPopup(container);
			//vc.setLayout(new BorderLayout());
		}
		
		private function el_buttons(e:Event):void {
			switch (e.target.name) {
			case 'bSend':
				dispatchEvent(ID_E_PRESSED, ID_B_SEND);
				break;
				
			}
		}
		
		
		
		private var reduceHeighWebVersion:int;
		private var width:int;
		private var vc:JPopup;
		private var it:JTextField;
		private var b:JButton;
		private var dt:JTextArea;
		private var dtScrollPane:JScrollPane;
		
		//{ ======= container
		private function prepareContainer():void {
			container = new Sprite();
			vc = new JPopup(container);
			vc.setLayout(new BorderLayout());
			vc.setMinimumWidth(width/2); vc.setMinimumHeight(300);
		
			//L
			var leftBlock:JPanel = new JPanel(new BoxLayout(BoxLayout.Y_AXIS, 5));
			//leftBlock.setMinimumWidth(width); leftBlock.setMinimumHeight(300);
			//leftBlock.setSizeWH(width, 300);
			
			// dt
			dt=new JTextArea("", 30, 50);
			dt.setEditable(false);dt.setWordWrap(true);
			dtScrollPane=new JScrollPane(dt, JScrollPane.SCROLLBAR_AS_NEEDED, JScrollPane.SCROLLBAR_NEVER);
			vc.append(dtScrollPane, BorderLayout.CENTER);
			
			
			var leftBlockInput:JPanel = new JPanel(new BorderLayout(0,0));
			leftBlockInput.setMinimumWidth(width); leftBlockInput.setMinimumHeight(25);
			leftBlockInput.setSizeWH(width, 25);
			
			//it
			it = new JTextField('');
			it.setWordWrap(true);
			it.setSizeWH(width / 3, 30);
			it.setMinimumWidth(width / 3); it.setMinimumHeight(30);
			leftBlockInput.append(it, BorderLayout.CENTER);
			
			var chatRef:VCChat=this;
			
			//enter b
			b= Lib.createIconAndButton('bSend', el_buttons, APP.lText().get_TEXT(Text.ID_TEXT_CHAT_SEND_BUTTON), [],false,true,APP.lText().get_TEXT(Text.ID_TEXT_CHAT_SEND_BUTTON),2);
			leftBlockInput.append(b, BorderLayout.EAST);
			
			// todo: chat feature
			//vc.append(leftBlockInput, BorderLayout.SOUTH);
			
			//vc.getContentPane().append(leftBlock, BorderLayout.CENTER);
			//vc.append(leftBlock, BorderLayout.CENTER);
			vc.show();
		
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
			w = width;
			h = vc.stage.stageHeight *(1-AVC.get_consoleHM())-reduceHeighWebVersion;
			vc.setSizeWH(w/2, h);
			vc.setBorder(new EmptyBorder(null, new Insets(20, 20, 20, 20)));
			vc.pack();
		}
		
		//} ======= END OF container
		
		
		//{ ======= events id 
		/**
		 * String button id
		 */
		public static const ID_E_PRESSED:String = '>ID_E_PRESSED';
		public static const ID_B_SEND:String = 'ID_B_SEND';
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
		
		
		
		public static const NAME:String = 'VCGameBoard';
		
	}
}