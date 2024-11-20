// Project TicTacToe
package t_t.c.ma {
	
	//{ ======= import
	import t_t.c.vcm.VCMChat;
	import t_t.c.vcm.VCMGameBoard;
	import t_t.d.a.DUApp;
	import t_t.d.a.DUAppAction;
	import t_t.d.app.i.IDUTTTGameSession;

	import t_t.media.Text;

	import t_t.APP;
	import t_t.Application;
	import t_t.c.ae.AEApp;
	import t_t.c.vcm.VCMScreen;
	import t_t.LOG;
	import t_t.LOGGER;
	import t_t.v.VCScreenMain;
	
	import tk.jinanoimateydragoncat.utils.flow.agents.AbstractAgentEnvironment;
	import tk.jinanoimateydragoncat.utils.flow.data.IAM;
	import tk.jinanoimateydragoncat.utils.flow.data.JDM;
	//} ======= END OF import
	
	
	/**
	 * application(game) manager - ctrl ALL
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class MApp extends AM {
		
		//{ ======= CONSTRUCTOR
		
		function MApp (app:Application) {
			super(NAME);
			a=app;
		}
		//} ======= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			var sm:JDM = details as JDM;
			switch (eventType) {
			
			case ID_A_STARTUP:
			case VCMScreen.ID_E_B_STATS_CLOSE:
				//Entry point
				e.listen(VCMScreen.ID_A_DISPLAY_SCREEN_INITIAL, null);
				break;
			
			case VCMScreen.ID_E_GAME_START_OFFLINE:
				onlineMode = false;
				e.listen(MTTTGameSession.ID_A_NEW_GAME, null);
				break;
				
			case VCMScreen.ID_E_GAME_START_ONLINE:
				onlineMode = true;
				e.listen(MGame.ID_A_START_ONLINE_GAME, null);
				break;
				
			case VCMScreen.ID_E_GAME_SESSION_RESET_CANCEL:
			case VCMScreen.ID_E_B_EXIT_APP_CANCEL:
				if (onlineMode) {
					e.listen(VCMScreen.ID_A_DISPLAY_SCREEN_PLAYING, {onlineMode:onlineMode});
					break;
				}
				
				
				var gs:IDUTTTGameSession = a.get_appData().get_gameSession();
				if (gs) {
					// show board or end game screen
					if (gs.get_active()) {
						e.listen(VCMScreen.ID_A_DISPLAY_SCREEN_PLAYING, {onlineMode:onlineMode});
					} else {
						e.listen(VCMScreen.ID_A_DISPLAY_SCREEN_SCORE_BOARD, null);
					}
				} else {
					// app just started
					e.listen(VCMScreen.ID_A_DISPLAY_SCREEN_INITIAL, null);
				}
				break;
				
			case VCMScreen.ID_E_B_EXIT_APP_WITHOUT_CONFIRMATION:
			case VCMScreen.ID_E_B_EXIT_APP_CONFIRM:
				e.listen(MFlashPlatform.ID_A_EXIT, null);
				break;
				
			case VCMScreen.ID_E_GAME_SESSION_RESET_CONFIRM:
				e.listen(MTTTGameSession.ID_A_NEW_GAME, null);
				break;
				
			case VCMScreen.ID_E_GAME_SESSION_RESET:
				e.listen(MTTTGameSession.ID_A_PAUSE_GAME, null);
				e.listen(VCMScreen.ID_A_DISPLAY_SCREEN_RESTART, null);
				break;
				
			case VCMScreen.ID_E_B_EXIT_APP:
				e.listen(MTTTGameSession.ID_A_PAUSE_GAME, null);
				e.listen(VCMScreen.ID_A_DISPLAY_SCREEN_EXIT_APP, null);
				break;
				
			case VCMGameBoard.ID_E_CELL_SELECTED:
				if (onlineMode) break;
				sm = JDM.getInstance();
				sm.si(0, details.x);
				sm.si(1, details.y);
				e.listen(MTTTGameSession.ID_A_SET_MARK, sm);
				sm.freeInstance();
				break;
				
			case MTTTGameSession.ID_E_END_OF_GAME:
				e.listen(VCMScreen.ID_A_DISPLAY_SCREEN_SCORE_BOARD, null);
				break;
				
			case MTTTGameSession.ID_E_NEW_SESSION:
				var om:JDM = JDM.getInstance();
				
				om.ss(0, a.get_appData().get_gameSession().get_board().get_id());
				e.listen(VCMGameBoard.ID_A_REDRAW_BOARD, om);om.freeInstance();
				
				e.listen(VCMScreen.ID_A_DISPLAY_SCREEN_PLAYING, {onlineMode:onlineMode});
				break;
				
			case MTTTGameSession.ID_E_SET_MARK:
				e.listen(VCMGameBoard.ID_A_SET_CELL_MARK, details);
				
			}
		}
		
		//{ ======= private 
		private var onlineMode:Boolean;
		
		//} ======= END OF private
		
		
		//{ ======= id
		public static const ID_A_STARTUP:String = NAME + "ID_A_STARTUP";
		//} ======= END OF id
		
		//{ ======= events
		//} ======= END OF events
		
		public static const NAME:String = 'MApp';
		
		public override function autoSubscribeEvents(envName:String):Array {
			return [
				ID_A_STARTUP
				,VCMScreen.ID_E_GAME_START_OFFLINE
				,VCMScreen.ID_E_GAME_START_ONLINE
				,VCMScreen.ID_E_GAME_STOP
				,VCMScreen.ID_E_SELECT_PLAYER
				,VCMScreen.ID_E_B_STATS_CLOSE
				
				,VCMScreen.ID_E_B_EXIT_APP
				,VCMScreen.ID_E_B_EXIT_APP_WITHOUT_CONFIRMATION
				,VCMScreen.ID_E_B_EXIT_APP_CONFIRM
				,VCMScreen.ID_E_B_EXIT_APP_CANCEL
				
				,VCMScreen.ID_E_GAME_SESSION_RESET
				,VCMScreen.ID_E_GAME_SESSION_RESET_CANCEL
				,VCMScreen.ID_E_GAME_SESSION_RESET_CONFIRM
				
				,VCMGameBoard.ID_E_CELL_SELECTED
				
				,MTTTGameSession.ID_E_SET_MARK
				,MTTTGameSession.ID_E_NEW_SESSION
				,MTTTGameSession.ID_E_END_SESSION
				,MTTTGameSession.ID_E_END_OF_GAME
			];
		}
		
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