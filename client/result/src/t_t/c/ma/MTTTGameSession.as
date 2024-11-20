// Project TicTacToe
package t_t.c.ma {
	
	//{ ======= import
	import t_t.APP;
	import t_t.Application;
	import t_t.c.ae.AEApp;
	import t_t.d.app.DUBoard;
	import t_t.d.app.DUBoardMark;
	import t_t.d.app.DUMarkType;
	import t_t.d.app.DUPlayer;
	import t_t.d.app.DUTTTGameSession;
	import t_t.d.app.i.IDUBoard;
	import t_t.d.app.i.IDUTTTGameSession;
	
	import t_t.LOG;
	import t_t.LOGGER;
	
	import tk.jinanoimateydragoncat.utils.flow.agents.AbstractAgentEnvironment;
	import tk.jinanoimateydragoncat.utils.flow.data.IAM;
	import tk.jinanoimateydragoncat.utils.flow.data.JDM;
	//} ======= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class MTTTGameSession extends AM {
		
		//{ ======= CONSTRUCTOR
		
		function MTTTGameSession (app:Application) {
			super(NAME);
			a=app;
		}
		//} ======= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			var m_:JDM = details as JDM;
			
			switch (eventType) {
			
				case ID_A_NEW_GAME:
					//refresh session
					var ps:IDUTTTGameSession = a.get_appData().get_gameSession();
					if (ps && ps.get_active()) { ps.finish(); }
					
					a.get_appData().set_gameSession(new DUTTTGameSession('offline', new DUBoard('offline')));
					a.get_appData().get_gameSession().addPlayer(new DUPlayer(DUBoardMark.PLAYER_ID_AI, DUMarkType.ID_TYPE_0));
					a.get_appData().get_gameSession().addPlayer(new DUPlayer(DUBoardMark.PLAYER_ID_YOU, DUMarkType.ID_TYPE_1));
					e.listen(ID_E_NEW_SESSION, null);
					break;
					
				//case ID_A_PAUSE_GAME:
					//noting 2do here
					//break;
					
				case ID_A_STOP_GAME:
					//lock session, calc stats
					a.get_appData().get_gameSession().finish();
					e.listen(ID_E_END_SESSION, null);
					break;
					
				case ID_A_SET_MARK:
					var bd:IDUBoard = a.get_appData().get_gameSession().get_board();
					// check whether cell is free, add mark
					m_.si(2, DUMarkType.ID_TYPE_1);
					if (!bd.setCellMark(new DUBoardMark(null, DUBoardMark.PLAYER_ID_YOU, m_.gi(2), m_.gi(0), m_.gi(1)))) {
						//test:
						//log(0, 'cell has mark already');
						break;// for m_.freeInstance
					}
					//log(0, 'set');
					e.listen(ID_E_SET_MARK, {x:m_.gi(0), y:m_.gi(1), markSN:m_.gi(2)});
					
					
					// TODO: check game state (victory conditions)
					// TODO: if no victory conditions, repeate above 3 steps with AI
					// TODO: detect x and y for AI mark
					if (bd.get_listCellMarks().length > 4) { a.get_appData().get_gameSession().finish(); e.listen(ID_E_END_OF_GAME, null); break; }
					
					m_.si(2, DUMarkType.ID_TYPE_0);
					
					do {
						m_.si(0, Math.min(2, Math.random() * 3));m_.si(1, Math.min(2, Math.random() * 3));
					} while (!bd.setCellMark(new DUBoardMark(null, DUBoardMark.PLAYER_ID_AI, m_.gi(2), m_.gi(0), m_.gi(1))));
					//{
					//	//log(0, 'ai - cell has mark already');
					//	break;// for m_.freeInstance
					//}
					//log(0, 'ai - set');
					e.listen(ID_E_SET_MARK, {x:m_.gi(0), y:m_.gi(1), markSN:m_.gi(2)});
					
					// TODO: check game state (victory conditions)
					if (bd.get_listCellMarks().length > 4) {a.get_appData().get_gameSession().finish();e.listen(ID_E_END_OF_GAME, null);}
					
					break;
					
			}
			
			if (m_) {m_.freeInstance();}
			
		}
		
	
		
		
		//{ ======= private 
		
		//} ======= END OF private
		
		
		//{ ======= id
		public static const ID_A_NEW_GAME:String = NAME + "ID_A_NEW_GAME";
		public static const ID_A_PAUSE_GAME:String = NAME + "ID_A_PAUSE_GAME";
		public static const ID_A_STOP_GAME:String = NAME + "ID_A_STOP_GAME";
		/**
		 * int:x, y, sn
		 */
		public static const ID_A_SET_MARK:String = NAME + "ID_A_SET_MARK";
		//} ======= END OF id
		
		//{ ======= events
		/**
		 * int:x, y, sn
		 */
		public static const ID_E_SET_MARK:String = NAME + "ID_E_SET_MARK";
		public static const ID_E_NEW_SESSION:String = NAME + "ID_E_NEW_SESSION";
		public static const ID_E_END_SESSION:String = NAME + "ID_E_END_SESSION";
		public static const ID_E_END_OF_GAME:String = NAME + "ID_E_END_OF_GAME";
		public static const ID_E_PLAYER_ACTION_MARK:String = NAME + "ID_E_PLAYER_ACTION_MARK";
		/**
		 * netwok event - remote user (owner of session) has stopped session
		 */
		public static const ID_E_PLAYER_ACTION_STOP_GAME:String = NAME + "ID_E_PLAYER_ACTION_STOP_GAME";
		//} ======= END OF events
		
		public static const NAME:String = 'MTTTGameSession';
		
		public override function autoSubscribeEvents(envName:String):Array {
			return [
				ID_A_NEW_GAME
				,ID_A_STOP_GAME
				,ID_A_SET_MARK
				,ID_E_END_OF_GAME
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