// Project TicTacToe
package t_t.c.vcm {
	
	//{ ======= import
	
	import t_t.d.app.DUBoardMark;
	import t_t.d.app.i.IDUTTTGameSession;
	import t_t.media.Text;
	import t_t.v.AVC;
	import t_t.v.VCGameUIMain;
	import t_t.v.VCScreen;
	import t_t.v.VCScreenExitApp;
	import t_t.v.VCScreenStartNewGame;
	
	import t_t.c.ae.AEApp;
	
	import t_t.APP;
	import t_t.Application;
	
	import t_t.LOG;
	import t_t.LOGGER;
	
	
	import tk.jinanoimateydragoncat.utils.flow.data.IAM;
	import tk.jinanoimateydragoncat.utils.flow.data.JDM;
	//} ======= END OF import
	
	/**
	 * display manager - controlls main interface
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class VCMScreen extends AVCM {
		
		//{ ======= CONSTRUCTOR
		
		function VCMScreen (app:Application) {
			super(NAME);
			a=app;
		}
		//} ======= END OF CONSTRUCTOR
		
		//{ ======= ======= controll
		
		public override function listen(eventType:String, details:Object):void {
			var m:JDM = (details as JDM);
			switch (eventType) {
			
			case ID_A_REGISTER_SINGLETON_VC:
				vc = m.go(0) as VCScreen;
				configureVC();
				break;
				
			case ID_A_DISPLAY_SCREEN_INITIAL:
				showOneScreenOnly(vc.get_screenStartNewGame());
				break;
			case ID_A_DISPLAY_SCREEN_LODING:
				break;
			case ID_A_DISPLAY_SCREEN_SELECT_2ND_PLAYER_TYPE:
				break;
				
			case ID_A_DISPLAY_SCREEN_PLAYING:
				vc.get_gameUIMain().setResetButtonVisibility(!details.onlineMode);
				showOneScreenOnly(vc.get_gameUIMain());
				break;
				
			case ID_A_DISPLAY_SCREEN_SCORE_BOARD:
				if (details) {
					//online mode
					vc.get_screenScreenStats().setText(details.youWon, -1);
					showOneScreenOnly(vc.get_screenScreenStats());
					break;
				}
				//update stats text:
				var gs:IDUTTTGameSession = a.get_appData().get_gameSession();
				var randomWinner4UIDemo:String = [DUBoardMark.PLAYER_ID_AI, DUBoardMark.PLAYER_ID_YOU][Math.min(1, uint(Math.random() * 2))];
				vc.get_screenScreenStats().setText(
					(gs.getPlayerById(randomWinner4UIDemo).get_id() == DUBoardMark.PLAYER_ID_YOU) ? 1 : 0
					,4
					//,int(Math.max(1, Math.random()*3))
					//,gs.get_totalMarks(randomWinner4UIDemo)
					//,gs.get_totalMarks(gs.get_winnerId())
				);
				showOneScreenOnly(vc.get_screenScreenStats());
				break;
				
			case ID_A_DISPLAY_SCREEN_RESTART:
				showOneScreenOnly(vc.get_screenRestartGameSession());
				break;
			case ID_A_DISPLAY_SCREEN_EXIT_APP:
				showOneScreenOnly(vc.get_screenExitApp());
				break;
				
			
				
			}
			
			if (m) {m.freeInstance();}
		}
		
		private function showOneScreenOnly(a:AVC):void {
			for each(var i:AVC in screensList) {
				if (i == a) { continue;}
				vc.get_screenMain().removeInterface(i.get_displayObject());
			}
			
			vc.get_gameBoard().get_displayObject().visible = a==vc.get_gameUIMain();
			vc.get_chat().get_displayObject().visible = a==vc.get_gameUIMain();
			
			if (!a) { return;}
			vc.get_screenMain().addInterface(a.get_displayObject());
		}
		
			
		private function configureVC():void {
			configureControll();
		}
		
		private function configureControll():void {
			vc.setListener(el_vc);
		}
		

		private function el_vc(target:VCScreen, eventType:String, details:Object = null):void {
			switch (eventType) {
			
			case AVC.ID_E_INTERFACE_ACCESSIBLE:
				vc.get_screenStartNewGame().setListener(el_screenStartNewGame);
				screensList.push(vc.get_screenStartNewGame());
				
				vc.get_screenExitApp().setListener(el_screenExitApp);
				screensList.push(vc.get_screenExitApp());
				
				vc.get_gameUIMain().setListener(el_gameUIMain);
				screensList.push(vc.get_gameUIMain());
				
				vc.get_screenRestartGameSession().setListener(el_screenScreenPause);
				screensList.push(vc.get_screenRestartGameSession());
				
				vc.get_screenScreenStats().setListener(el_screenScreenStats);
				screensList.push(vc.get_screenScreenStats());
				break;
			
			}
		}
		
		private function el_gameUIMain(target:AVC, eventType:String, details:Object = null):void {
			switch (details) {
			case VCGameUIMain.ID_E_B_PAUSE_EXIT:
				e.listen(ID_E_B_EXIT_APP, null);
				break;
			case VCGameUIMain.ID_E_B_RESTART:
				e.listen(ID_E_GAME_SESSION_RESET, null);
				break;
			}	
		}
		
		private function el_screenScreenStats(target:AVC, eventType:String, details:Object = null):void {
			//back to initial
			//e.listen(ID_E_B_STATS_CLOSE, null);
			e.listen(ID_E_B_EXIT_APP_WITHOUT_CONFIRMATION, null);
		}
		
		private function el_screenScreenPause(target:AVC, eventType:String, details:Object = null):void {
			switch (details) {
			case VCScreenExitApp.ID_E_B_Y:
				e.listen(ID_E_GAME_SESSION_RESET_CONFIRM, null);
				break;
			case VCScreenExitApp.ID_E_B_N:
				e.listen(ID_E_GAME_SESSION_RESET_CANCEL, null);
				break;
			}
		}
		
		private function el_screenExitApp(target:AVC, eventType:String, details:Object = null):void {
			switch (details) {
			case VCScreenExitApp.ID_E_B_Y:
				e.listen(ID_E_B_EXIT_APP_CONFIRM, null);
				break;
			case VCScreenExitApp.ID_E_B_N:
				e.listen(ID_E_B_EXIT_APP_CANCEL, null);
				break;
			}
		}
		
		private function el_screenStartNewGame(target:AVC, eventType:String, details:Object = null):void {
			//switch (eventType) {
			//case VCScreenStartNewGame.ID_E_B_ACTION:
				switch (details) {
				case VCScreenStartNewGame.ID_E_B_START_OFFLINE:
					e.listen(ID_E_GAME_START_OFFLINE, null);
					break;
				case VCScreenStartNewGame.ID_E_B_START_ONLINE:
					e.listen(ID_E_GAME_START_ONLINE, null);
					break;
				case VCScreenStartNewGame.ID_E_B_EXIT:
					e.listen(ID_E_B_EXIT_APP, null);
					break;
				}
		}
		
				
		 
		
		//} ======= ======= END OF controll
		
		
		//{ ======= private 
		
		private var screensList:Vector.<AVC>=new Vector.<AVC>;
		//} ======= END OF private
		
		
		//{ ======= ======= id
		/**
		 * data:VCMainScreen
		 */
		public static const ID_A_REGISTER_SINGLETON_VC:String = NAME + '>ID_A_REGISTER_SINGLETON_VC';
		
		public static const ID_A_DISPLAY_SCREEN_INITIAL:String = NAME + '>ID_A_DISPLAY_SCREEN_INITIAL';
		public static const ID_A_DISPLAY_SCREEN_LODING:String = NAME + '>ID_A_DISPLAY_SCREEN_LODING';
		public static const ID_A_DISPLAY_SCREEN_SELECT_2ND_PLAYER_TYPE:String = NAME + '>ID_A_DISPLAY_SCREEN_SELECT_2ND_PLAYER_TYPE';
		/**
		 * {onlineMode:bool}
		 */
		public static const ID_A_DISPLAY_SCREEN_PLAYING:String = NAME + '>ID_A_DISPLAY_SCREEN_PLAYING';
		/**
		 * if details are present - will use details (online mode)
		 * {bool youWon}
		 */
		public static const ID_A_DISPLAY_SCREEN_SCORE_BOARD:String = NAME + '>ID_A_DISPLAY_SCREEN_SCORE_BOARD';
		public static const ID_A_DISPLAY_SCREEN_RESTART:String = NAME + '>ID_A_DISPLAY_SCREEN_RESTART';
		public static const ID_A_DISPLAY_SCREEN_EXIT_APP:String = NAME + '>ID_A_DISPLAY_SCREEN_EXIT_APP';
		
		//{ ======= events
		
		public static const ID_E_GAME_SESSION_RESET:String = NAME + '>ID_E_GAME_SESSION_RESET';
		public static const ID_E_GAME_SESSION_RESET_CONFIRM:String = NAME + '>ID_E_GAME_SESSION_RESET_CONFIRM';
		public static const ID_E_GAME_SESSION_RESET_CANCEL:String = NAME + '>ID_E_GAME_SESSION_RESET_CANCEL';
		
		public static const ID_E_GAME_START_OFFLINE:String = NAME + '>ID_E_GAME_START_OFFLINE';
		public static const ID_E_GAME_START_ONLINE:String = NAME + '>ID_E_GAME_START_ONLINE';
		public static const ID_E_GAME_STOP:String = NAME + '>ID_E_GAME_STOP';
		public static const ID_E_B_STATS_CLOSE:String = NAME + '>ID_E_B_STATS_CLOSE';
		
		public static const ID_E_B_EXIT_APP:String = NAME + '>ID_E_B_EXIT_APP';
		public static const ID_E_B_EXIT_APP_WITHOUT_CONFIRMATION:String = NAME + '>ID_E_B_EXIT_APP_WITHOUT_CONFIRMATION';
		public static const ID_E_B_EXIT_APP_CONFIRM:String = NAME + '>ID_E_B_EXIT_APP_CONFIRM';
		public static const ID_E_B_EXIT_APP_CANCEL:String = NAME + '>ID_E_B_EXIT_APP_CANCEL';
		
		public static const ID_E_SELECT_PLAYER:String = NAME + '>ID_E_SELECT_PLAYER';
		
		//} ======= END OF events
		
		//} ======= ======= END OF id
		
		public override function autoSubscribeEvents(envName:String):Array {
			return [
				ID_A_REGISTER_SINGLETON_VC
				,ID_A_DISPLAY_SCREEN_INITIAL
				,ID_A_DISPLAY_SCREEN_LODING
				,ID_A_DISPLAY_SCREEN_SELECT_2ND_PLAYER_TYPE
				,ID_A_DISPLAY_SCREEN_PLAYING
				,ID_A_DISPLAY_SCREEN_SCORE_BOARD
				,ID_A_DISPLAY_SCREEN_RESTART
				,ID_A_DISPLAY_SCREEN_EXIT_APP
			];
		}
		
		public static const NAME:String = 'VCMScreen';
		
		
				
		//{ ======= private 
		private var vc:VCScreen;
		//} ======= END OF private
		
		
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
		
		
	}
}