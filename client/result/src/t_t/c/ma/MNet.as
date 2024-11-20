// Project TicTacToe
package t_t.c.ma {
	
	//{ ======= import

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import t_t.Application;
	import t_t.LOG;
	import t_t.LOGGER;
	import t_t.data.NPMessages;
	
	import tk.jinanoimateydragoncat.utils.flow.data.IAM;
	import tk.jinanoimateydragoncat.utils.flow.data.JDM;
	//} ======= END OF import
	
	
	/**
	 * network
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class MNet extends AM {
		
		//{ ======= CONSTRUCTOR
		
		/**
		 * everything network related
		 * binary socket
		 * @param	app
		 * @param	socketReconnectInterval seconds
		 */
		function MNet (app:Application, host:String, port:int, socketReconnectInterval:uint) {
			super(NAME);
			a = app;
			this.socketReconnectInterval = socketReconnectInterval;
			this.host = host;
			this.port = port;
			
			prepareNetwork();
		}
		//} ======= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			var sm:JDM = details as JDM;
			switch (eventType) {
			
				case ID_A_JOIN:
					// socket connect
					loggedOut = true;
					loggedOutManually = false;
					break;
					
				case ID_E_SOCKET_RECONNECTED:
					net_sendMsgLogin();
					break;
					
				case ID_E_SOCKET_CONNECTED:
					//socket onConnect: send msg JOIN
					net_sendMsgJoin();
					break;
					
				case ID_A_RECONNECT:
					break;
					
				case ID_A_LOGOUT:
					loggedOutManually = true;
					break;
					
				case ID_A_SET_MARK:
					net_sendMsgSetMark(details.x, details.y);
					break;
					
				case ID_A_STARTUP:
					break;
					
				
			}
		}
		
		//{ OUTGOING MESSAGES:

		
		private function net_sendMsgJoin():void {
			var type:int = NPMessages.TYPE_IN_PLAYER_JOIN;
			socket.writeInt(type);
			
			playerName = 'TEST_PLAYER_name-in-client';
			writeStringToSocket(socket, playerName);
			
			socket.flush();
		}

		
		private function net_sendMsgLogin():void {
			if (!playerId) {
				LOG(LOGGER.C_OP, 'cannot login cuz player id is null. connect, join, disconnect, connect, then login');
				return;
			}
			
			var type:int = NPMessages.TYPE_IN_PLAYER_LOGIN;
			socket.writeInt(type);
			
			writeStringToSocket(socket, playerId);
			writeStringToSocket(socket, playerName);
			
			socket.flush();
		}

		private function net_sendMsgLogout():void {
			var type:int = NPMessages.TYPE_IN_PLAYER_LOGOUT;
			socket.writeInt(type);
			socket.flush();
		}

		private function net_sendMsgSetMark(x:int, y:int):void {
			if (!socket.connected) return;
			//log(0, 'write to socket:' + x);
			var type:int = NPMessages.TYPE_IN_PLAYER_MOVE;
			socket.writeInt(type);
			
			socket.writeInt(x);//x
			socket.writeInt(y);//y
			
			socket.flush();
		}
		//}
		
		
		//{ INCOMING MESSAGES:
		
		private function processIncomingSocketData(socket:Socket):void {
			//try {
			
			var type:int = socket.readInt();
			var pid:String;
			
			switch(type) {
				
				case NPMessages.TYPE_OUT_YOUR_ID://player_join
					//socket onMsg: JOINED: store playerId
					playerId = readStringFromSocket(socket);
					LOG(LOGGER.C_OP, 'player_join THIS player id=' + playerId);
					//send event
					e.listen(ID_E_YOU_JOINED_ROOM, null);
					break;
					
				case NPMessages.TYPE_OUT_PLAYER_JOINED_ROOM://other player join
					pid = readStringFromSocket(socket);
					var pln:String = readStringFromSocket(socket);
					LOG(LOGGER.C_OP, 'player JOINED id=' + pid);
					e.listen(ID_E_PLAYER_JOINED_ROOM, {name:pln});
					break;
					
				case NPMessages.TYPE_OUT_PLAYER_LEFT_ROOM_TEMP://other player left temp
					pid = readStringFromSocket(socket);
					LOG(LOGGER.C_OP, 'player lost connection, waiting for him. id=' + pid);
					e.listen(ID_E_PARTNER_CONNECTION_LOST, null);
					break;
					
				case NPMessages.TYPE_OUT_PLAYER_LEFT_ROOM_PERM://other player left perm
					pid = readStringFromSocket(socket);
					LOG(LOGGER.C_OP, 'player LEFT id=' + pid);
					break;
					
				case NPMessages.TYPE_OUT_PLAYER_ENTERED_ROOM://player came back
					pid = readStringFromSocket(socket);
					var pn:String = readStringFromSocket(socket);
					LOG(LOGGER.C_OP, 'player '+pn+' RESTORED connection, id=' + pid);
					e.listen(ID_E_PARTNER_CONNECTION_RESTORED, null);
					break;
					
				case NPMessages.TYPE_OUT_GAME_STARTED://game started
					var firstPlayerId:String = readStringFromSocket(socket);
					Mark1PlayerId = readStringFromSocket(socket);
					LOG(LOGGER.C_OP, 'Game STARTED, firstPlayerId=' + firstPlayerId + ' Mark1PlayerId=' + Mark1PlayerId);
					
					var isYourTurn:Boolean = playerId.indexOf(firstPlayerId) !== -1;
					if (isYourTurn) {
						LOG(LOGGER.C_OP, '       it is YOUR turn, ' + playerName+' make your mark');
					} else {
						LOG(LOGGER.C_OP, "it is player "+firstPlayerId+" turn, wait for him to put a mark");
					}
					e.listen(ID_E_GAME_STARTED, { isYourTurn:isYourTurn} );
					break;
				
				case NPMessages.TYPE_OUT_PLAYER_MOVE://set mark
					pid = readStringFromSocket(socket);
					var pid2:String = readStringFromSocket(socket);
					var markX:int = socket.readInt();
					var markY:int = socket.readInt();
					var winnerMarkSN:int = socket.readInt();
					
					var playerString:String = "your";
					
					if (playerId.indexOf(pid) == -1) {// not you have marked
						playerString = "player " + pid + " put a";
					}
					
					//LOG(LOGGER.C_OP, playerId+".indexOf("+pid+")=" + playerId.indexOf(pid));
					LOG(LOGGER.C_OP, playerString + ' mark:' + markX + '/' + markY + ' ;winnerMarkSN=' + winnerMarkSN);
					e.listen(ID_E_MARK_SET, { x:markX, y:markY, markSN:getMarkSNForPlayer(pid2) } );
					
					const EMPTY_CELL:int = 0;
					const BOARD_IS_FULL:int = -1;
					if (winnerMarkSN != EMPTY_CELL) {
						var markSN:int = 2;
						//LOG(LOGGER.C_OP, "winner test: "+playerId+".indexOf("+Mark1PlayerId+")");

						if (playerId.indexOf(Mark1PlayerId) != -1) {
							markSN = 1;
						}
						if (winnerMarkSN === markSN) {
							LOG(LOGGER.C_OP, "GAME OVER, you won");
							e.listen(ID_E_GAME_OVER, { youWon: 1, numMoves:numMoves} );
						} else if (winnerMarkSN === BOARD_IS_FULL) {
							LOG(LOGGER.C_OP, "GAME OVER, noone's won, the board is full");
							e.listen(ID_E_GAME_OVER, { youWon: -1, numMoves:numMoves} );
						} else {
							LOG(LOGGER.C_OP, "GAME OVER, you have lost");
							e.listen(ID_E_GAME_OVER, { youWon: 0, numMoves:numMoves} );
						}
						e.listen(ID_A_LOGOUT, null);
						break;
					}
					
				//case NPMessages.502://player turn
					//LOG(LOGGER.C_OP, ' turn msg INC pid='+pid);
					srv_displayTurnText(pid2);
					break;
					
				case NPMessages.TYPE_OUT_GAME_SESSION_DATA://TYPE_OUT_GAME_SESSION_DATA
					//id int(x9)
					pid = readStringFromSocket(socket);
					
					var boardData:Array = [];
					for (var i:int = 0; i < 9; i++) {
						boardData.push(socket.readInt());
					}
					
					LOG(LOGGER.C_NET, "received session data: GameBoard data=[" + boardData.join(",") + "]");
					if (pid.indexOf("no id") == -1) {
						srv_displayTurnText(pid);
					} else {
						log(LOGGER.C_OP, "todo: waiting for other players?");
					}
					e.listen(ID_E_BOARD_DATA, { bd:boardData } );
					break;
					
				default:
					LOG(LOGGER.C_NET, "Received from server: " + type);
					break;
					
			}
			
			if (socket.bytesAvailable > 0) {
				//LOGGER.log(0, '!!! socket.bytesAvailable !!!', 2);
				onSocketData(null);
			}
			
			/*} catch (e:Error) {
				Application.chatMessage("ошибка чтения данных из сокета. пожалуйста выйдете и зайдите в игру.");
				log(LOGGER.C_OP, "TODO: use packet numeration or other solution to fix socket read errors");
				//todo: use packet numeration or other solution to fix socket read errors
			}*/
		}
		//}
		
		//{ low level
		
		private function prepareNetwork():void {
			LOG(LOGGER.C_NET, 'prepareNetwork',0);
			
			try {
				socket= new Socket();
				socket.addEventListener(Event.CONNECT, onSocketConnect);
				socket.addEventListener(Event.CLOSE, onSocketClose);
				socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
				prepareAndRunReconnectTimer();
			} catch (e:Error) {
				LOG(LOGGER.C_NET, 'socket prep error:' + e.name+'/' + e.message);
			}
		}
		
		private function prepareAndRunReconnectTimer():void {
			//todo: reconnect by timer
			var timer:Timer = new Timer(socketReconnectInterval * 1000);
			timer.addEventListener(TimerEvent.TIMER, onNetRTimer);
			timer.start();
			
		}
		private function onNetRTimer(event:TimerEvent):void {
			reconnectSocket();
		}
		
		private function reconnectSocket():void {
			//if player left room - do not reconnect
			if (!loggedOutManually && loggedOut) {
				socket.connect(host, port);
				log(LOGGER.C_NET, 'socket: reconnect');
			}
		}
		
		private function onSocketConnect(event:Event):void {
			LOG(LOGGER.C_NET, "socket: connected.");
			loggedOut = false;
			if (!loggedOutManually) {//not logged out, join room
				if (playerId==null) {
					listen(ID_E_SOCKET_CONNECTED, null);
				} else {
					listen(ID_E_SOCKET_RECONNECTED, null);	
				}
			}
		}
		private function onSocketClose(event:Event):void {
			LOG(LOGGER.C_NET, "socket: connection lost / disconnected");
			listen(ID_E_CONNECTION_LOST, null);
			listen(ID_A_RECONNECT, null);
		}
		
		
		private function onIOError(event:IOErrorEvent):void {
			LOG(LOGGER.C_NET, "socket: IO Error: " + event.text);
		}
		
		private function onSocketData(event:ProgressEvent):void {
			processIncomingSocketData(socket);
		}
		//}
		
		//{ helpers
		
		
		private function getMarkSNForPlayer(playerId:String):int {
			return (this.Mark1PlayerId.indexOf(playerId) != -1) ? MARK1 : MARK2;
		}
		
		private static const MARK1:int = 1;
		private static const MARK2:int = 2;
		
		private function readStringFromSocket(socket:Socket):String {
			var len:int = socket.readInt();
			//LOG(LOGGER.C_OP, "str len: " + len);
			var stringValue:String = socket.readUTFBytes(len);
			//LOG(LOGGER.C_OP, "string: " + stringValue);
			return stringValue;
		}
		
		private function writeStringToSocket(socket:Socket, string:String):void {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTF(string);
			
			socket.writeInt(bytes.length);
			//LOG(LOGGER.C_OP, 'write str:"' + string + '" len=' + string.length + 'bytes.length=' + bytes.length);
			socket.writeBytes(bytes);
		}
		
		private function srv_displayTurnText(pid:String):void {
			if (playerId.indexOf(pid) == -1) {// not your
				LOG(LOGGER.C_OP, "player " + pid + " turn. wait for him to set a mark");
			} else {
				LOG(LOGGER.C_OP, "      your turn to set a mark");
			}
			e.listen(ID_E_TURN_INFO, { isYourTurn:(playerId.indexOf(pid) != -1) } );
		}
		//}

		
		//{ ======= private 
		
		private var host:String;
		private var port:int;
		private var socketReconnectInterval:uint;
		private var socket:Socket;
		
		
		private var loggedOut:Boolean = true;
		private var loggedOutManually:Boolean = true;
		
		private var playerId:String = null;
		private var Mark1PlayerId:String;
		private var numMoves:int;
		private var playerName:String="noNAME";		
		
		//} ======= END OF private
		
		
		//{ ======= id
		
		/**
		 * подключиться к серверу и начать игру
		 */
		public static const ID_A_JOIN:String = NAME + ">ID_A_JOIN";
		/**
		 * повторить попытку переподключения при потере связи
		 */
		public static const ID_A_RECONNECT:String = NAME + ">ID_A_RECONNECT";
		/**
		 * выйти
		 */
		public static const ID_A_LOGOUT:String = NAME + ">ID_A_LOGOUT";
		/**
		 * сделать ход {int x, int y}
		 */
		public static const ID_A_SET_MARK:String = NAME + ">ID_A_SET_MARK";
		
		
		public static const ID_A_STARTUP:String = NAME + ">ID_A_STARTUP";
		//} ======= END OF id
		
		//{ ======= events
		
		/**
		 * {}
		 */
		public static const ID_E_YOU_JOINED_ROOM:String = NAME + ">ID_E_YOU_JOINED_ROOM";
		public static const ID_E_PLAYER_JOINED_ROOM:String = NAME + ">ID_E_PLAYER_JOINED_ROOM";
		/**
		 * {isYourTurn}
		 */
		public static const ID_E_TURN_INFO:String = NAME + ">ID_E_TURN_INFO";
		/**
		 * {bd:[int]}
		 */
		public static const ID_E_BOARD_DATA:String = NAME + ">ID_E_BOARD_DATA";
		/**
		 * {x, y, markSN}
		 */
		public static const ID_E_MARK_SET:String = NAME + ">ID_E_MARK_SET";
		/**
		 * {bool youWon}
		 */
		public static const ID_E_GAME_OVER:String = NAME + ">ID_E_GAME_OVER";
		/**
		 * {bool isYourTurn}
		 */
		public static const ID_E_GAME_STARTED:String = NAME + ">ID_E_GAME_STARTED";
		/**
		 * {}
		 */
		public static const ID_E_CONNECTION_LOST:String = NAME + ">ID_E_CONNECTION_LOST";
		/**
		 * {}
		 */
		public static const ID_E_CONNECTION_RESTORED:String = NAME + ">ID_E_CONNECTION_RESTORED";
		public static const ID_E_PARTNER_CONNECTION_LOST:String = NAME + ">ID_E_PARTNER_CONNECTION_LOST";
		public static const ID_E_PARTNER_CONNECTION_RESTORED:String = NAME + ">ID_E_PARTNER_CONNECTION_RESTORED";
		
		///private events
		
		private static const ID_E_SOCKET_CONNECTED:String = NAME + ">ID_E_SOCKET_CONNECTED";
		private static const ID_E_SOCKET_RECONNECTED:String = NAME + ">ID_E_SOCKET_RECONNECTED";

		//} ======= END OF events
		
		public static const NAME:String = 'MNet';
		
		public override function autoSubscribeEvents(envName:String):Array {
			return [
				ID_A_STARTUP
				,ID_A_RECONNECT
				,ID_A_SET_MARK
				,ID_A_LOGOUT
				,ID_A_JOIN
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