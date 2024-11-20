// Project TicTacToe
package t_t.c.ma {
	
	//{ ======= import
	import t_t.c.vcm.VCMGameBoard;
	import t_t.d.a.DUApp;
	import t_t.d.a.DUAppAction;
	import t_t.d.app.i.IDUTTTGameSession;
	import tk.jinanoimateydragoncat.utils.flow.data.JDM;

	import t_t.media.Text;

	import t_t.APP;
	import t_t.Application;
	import t_t.c.ae.AEApp;
	import t_t.c.vcm.VCMScreen;
	import t_t.LOG;
	import t_t.LOGGER;
	import t_t.v.VCScreenMain;
	
	//} ======= END OF import
	
	
	/**
	 * network
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class MGame extends AM {
		
		//{ ======= CONSTRUCTOR
		
		function MGame (app:Application) {
			super(NAME);
			a=app;
		}
		//} ======= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			var sm:JDM = details as JDM;
			switch (eventType) {
				
				case ID_A_START_ONLINE_GAME:
					e.listen(MNet.ID_A_JOIN, null);
					break;
					
				case MNet.ID_E_YOU_JOINED_ROOM:
					e.listen(VCMScreen.ID_A_DISPLAY_SCREEN_PLAYING, {onlineMode:true});
					e.listen(VCMGameBoard.ID_A_CLEAR_BOARD, {w:3, h:3});
					Application.chatMessage('вы подключились к комнате, ожидайте других игроков');
					break;
					
				case MNet.ID_E_GAME_STARTED:
					Application.chatMessage('== игра началась, '+((details.isYourTurn)?"ваша очередь ходить, делайте ход":"сейчас очередь другого игрока ходить, ждите"));
					break;
					
				case MNet.ID_E_TURN_INFO:
					Application.chatMessage((details.isYourTurn)?"ваша очередь ходить, делайте ход":"сейчас очередь другого игрока ходить, ждите");
					break;
					
				case MNet.ID_E_PLAYER_JOINED_ROOM:
					Application.chatMessage('другой игрок подключился к игре. его зовут: "'+details.name+'"');
					break;
					
				case VCMGameBoard.ID_E_CELL_SELECTED:
					e.listen(MNet.ID_A_SET_MARK, details);
					break;
					
				case MNet.ID_E_BOARD_DATA:
					e.listen(VCMGameBoard.ID_A_LOAD_BOARD_DATA, details.bd);
					break;
					
				case MNet.ID_E_MARK_SET:
					e.listen(VCMGameBoard.ID_A_SET_CELL_MARK, details);
					break;
					
				case MNet.ID_E_GAME_OVER:
					e.listen(VCMScreen.ID_A_DISPLAY_SCREEN_SCORE_BOARD, details);
					break;
					
				case MNet.ID_E_PARTNER_CONNECTION_LOST:
					Application.chatMessage('другой игрок потерял связь с сервером. вы можете подождать его либо перезайти, чтобы играть заново с другим игроком');
					break;
					
				case MNet.ID_E_PARTNER_CONNECTION_RESTORED:
					Application.chatMessage('другой игрок снова подключился');
					break;
					
				case MNet.ID_E_CONNECTION_LOST:
					//add chat message "c lost, reconnecting..."
					Application.chatMessage('соединение прервано, идет переподключение, ожидайте пожалуйста');
					
					//todo in MNet ignore player action if disconnected - in socted, before sending, check whether it is connected
					break;
				
				case MNet.ID_E_CONNECTION_RESTORED:
					//add chat message "conn restored"
					Application.chatMessage('соединение восстановлено');
					//todo in MNet ignore player action if disconnected - in socted, before sending, check whether it is connected
					break;
					
				
			}
		}
		
		//{ ======= private 
		
		//} ======= END OF private
		
		
		//{ ======= id
		
		/**
		 * подключиться к серверу и начать игру
		 */
		public static const ID_A_START_ONLINE_GAME:String = NAME + ">ID_A_START_ONLINE_GAME";
		
		public static const ID_A_STARTUP:String = NAME + ">ID_A_STARTUP";
		//} ======= END OF id
		
		//{ ======= events
		//} ======= END OF events
		
		public static const NAME:String = 'MGame';
		
		public override function autoSubscribeEvents(envName:String):Array {
			return [
				ID_A_STARTUP
				
				,ID_A_START_ONLINE_GAME
				,MNet.ID_E_YOU_JOINED_ROOM
				,MNet.ID_E_PLAYER_JOINED_ROOM
				,MNet.ID_E_MARK_SET
				,MNet.ID_E_GAME_OVER
				,MNet.ID_E_CONNECTION_LOST
				,MNet.ID_E_CONNECTION_RESTORED
				,MNet.ID_E_GAME_STARTED
				,MNet.ID_E_TURN_INFO
				,MNet.ID_E_PARTNER_CONNECTION_RESTORED
				,MNet.ID_E_PARTNER_CONNECTION_LOST
				,MNet.ID_E_BOARD_DATA
				
				,VCMGameBoard.ID_E_CELL_SELECTED
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