// Project TicTacToe
package t_t.v {
	
	//{ ======= import
	import flash.display.DisplayObjectContainer;
	import org.aswing.AsWingManager;
	import t_t.LOG;
	
	//} ======= END OF import
	
	
	/**
	 * view main (non-physical)
	 * contains refs to view objects, data storage
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class VCScreen extends AVC {
		
		//{ ======= CONSTRUCTOR
		function VCScreen (appContainer:DisplayObjectContainer) {
			ac = appContainer;
			prepareScreens();
			configureControll();
			
		}
		//} ======= END OF CONSTRUCTOR
		
		
		
		//{ ===== controll
		private function configureControll():void {
			screenStartNewGame.setListener(el_childVC);
			screenExitApp.setListener(el_childVC);
			gameBoard.setListener(el_childVC);
			gameUIMain.setListener(el_childVC);
			screenScreenPause.setListener(el_childVC);
			screenScreenStats.setListener(el_childVC);
		}
		
		private function el_childVC(target:AVC, eventType:String, details:Object = null):void {
			switch (eventType) {
			case AVC.ID_E_INTERFACE_ACCESSIBLE:
				childVCsReportedAccessible += 1;
				break;
			}
			if (childVCsReportedAccessible >= childVCs.length) {dispatchEvent(AVC.ID_E_INTERFACE_ACCESSIBLE);}
		}
		
		private var childVCsReportedAccessible:int=0;
		private const childVCs:Vector.<AVC> = new Vector.<AVC>;
		//} ===== END OF controll
		
		
		public function prepareCustomUILibs():void {
			var scr:VCScreenMain = get_screenMain();
			AsWingManager.setRoot(scr.get_interfaceLayer());
			AsWingManager.initAsStandard(scr.get_interfaceLayer(), false);
				
		}
		
		private function prepareScreens():void {
			screenMain = new VCScreenMain(ac.stage.stageWidth, ac.stage.stageHeight*(1-AVC.get_consoleHM()));
			ac.addChild(screenMain.get_displayObject());
			
			screenStartNewGame = new VCScreenStartNewGame(ac.stage.stageWidth, ac.stage.stageHeight *(1-AVC.get_consoleHM()));
			childVCs.push(screenStartNewGame);
			
			screenExitApp = new VCScreenExitApp(ac.stage.stageWidth, ac.stage.stageHeight*(1-AVC.get_consoleHM()));
			childVCs.push(screenExitApp);
			
			var bottomMenuHeigh:int = 70;
			gameBoard = new VCGameBoard(bottomMenuHeigh);
			childVCs.push(gameBoard);
			screenMain.get_boardLayer().addChild(gameBoard.get_displayObject());
			
			chat = new VCChat(bottomMenuHeigh, ac.stage.stageWidth);
			chat.get_displayObject().x = ac.stage.stageWidth / 2;
			
			//childVCs.push(chat);
			screenMain.get_boardLayer().addChild(chat.get_displayObject());
			
			
			gameUIMain = new VCGameUIMain(ac.stage.stageWidth, bottomMenuHeigh);
			childVCs.push(gameUIMain);
			
			screenScreenPause = new VCScreenPause(ac.stage.stageWidth, ac.stage.stageHeight);
			childVCs.push(screenScreenPause);
			
			screenScreenStats = new VCScreenStats(ac.stage.stageWidth, ac.stage.stageHeight);
			childVCs.push(screenScreenStats);
			
		}
		
		private var screenMain:VCScreenMain;
		//private var screenScreenLoading:VCScreenLoading;
		//private var screenScreenSelectPlayerType:VCScreenSelectPlayerType;
		private var screenStartNewGame:VCScreenStartNewGame;
		private var screenScreenPause:VCScreenPause;
		//private var screenScreenReqYesNo:VCScreenReqYesNo;
		private var screenExitApp:VCScreenExitApp;
		private var gameBoard:VCGameBoard;
		private var chat:VCChat;
		private var screenScreenStats:VCScreenStats;
		private var gameUIMain:VCGameUIMain;
		//private var screenGameUIPlayer:VCGameUIMain;
		
		public function get_screenMain():VCScreenMain {return screenMain;}
		public function get_screenStartNewGame():VCScreenStartNewGame {return screenStartNewGame;}
		public function get_screenRestartGameSession():VCScreenPause {return screenScreenPause;}
		public function get_screenExitApp():VCScreenExitApp {return screenExitApp;}
		public function get_screenScreenStats():VCScreenStats {return screenScreenStats;}
		
		public function get_gameBoard():VCGameBoard {return gameBoard;}
		public function get_chat():VCChat {return chat;}
		public function get_gameUIMain():VCGameUIMain {return gameUIMain;}
		
		
		
		private var ac:DisplayObjectContainer;

			

		
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
		
		
		
		public static const NAME:String = 'VCScreen';
		
	}
}