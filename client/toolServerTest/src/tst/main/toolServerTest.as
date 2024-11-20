// Project toolServerTest
package tst.main {
	
	//{ -> import
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	
	import flash.events.Event;
	
	import com.junkbyte.console.Console;
	import com.junkbyte.console.ConsoleChannel;
	import com.junkbyte.console.ConsoleConfig;
	
	import tst.lib.Library;
	import tst.LOG;
	import tst.LOGGER;
	import tst.data.ApplicationConstants;
	//} -> END OF import
	
	
	/**
	 * Main
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 
	 */
	public class toolServerTest extends Sprite {
		
		//{ -> CONSTRUCTOR
		
		function toolServerTest () {
			if (stage) {init();}
			else {addEventListener(Event.ADDED_TO_STAGE, init);}
		}
		
		private function init(e:Event=null):void {
			//{ > prepare
			Library.initialize(libraryInitialized);
			if (e) {removeEventListener(e.type, arguments.callee);}
			//} > END OF prepare
		}
		private function libraryInitialized():void {
			// tip: press "`" button to display/hide console
			prepareConsole(ApplicationConstants.AppW, ApplicationConstants.AppH, ApplicationConstants.AppH/3);
			// show console:
			c.visible=true;
			
			prepareLogging();
			prepareView();
			prepareControl();
			prepareNetwork();
			run();
		}
		
		//} -> END OF CONSTRUCTOR
		
		
		
		//{ -> run application
		private function run():void {
			LOG(LOGGER.C_OP, 'run',0);
			// entry point
			LOG(LOGGER.C_OP, 'app cfg: host='+host+' ; port=' + port);
			createButtons();
			
		}
		//} -> END OF run application
		
		
		
		//{ -> view
		private function prepareView():void {
			LOG(LOGGER.C_OP, 'prepareView',0);
			addChild(uiLayer);
		}
		
		private function createButtons():void {
			for (var i:uint in testActionsList) {
				createButton(uiLayer, function(actionId:String):void { el_testActionSelected(parseInt(actionId)); }, testActionsList[i], i);
			}
		}
		
		private function createButton(container:DisplayObjectContainer, actionListener:Function, title:String, actionID:String):Sprite {
			var button:Sprite = container.addChild(new Sprite());
			//button.buttonMode = true;
			var label:TextField = button.addChild(new TextField());
			label.text = title;
			label.setTextFormat(new TextFormat("Arial", 20, 0x000000));
			label.autoSize = TextFieldAutoSize.LEFT;
			label.selectable = false;
			
			button.y = (button.height+10) * numButtons;

			button.graphics.beginFill(0x00ffff, 0.7);
			button.graphics.drawRect(0, 0, label.width, label.height);
			
			button.addEventListener(MouseEvent.CLICK, function (e:Event):void {
					actionListener(actionID);
			});
			numButtons += 1;
		}
		private var numButtons:uint = 0;
		
		private const uiLayer:Sprite = new Sprite();
		//} -> END OF view
		
		
		
		//{ -> control
		private function prepareControl():void {
			LOG(LOGGER.C_OP, 'prepareControl', 0);
			createButtonTitles();
			
		}
		
		private function createButtonTitles():void {
			/*
			testActionsList.push('connect to ' + host + ':' + port);//TestAction.ID_A_CONNECT
			testActionsList.push('disconnect');
			testActionsList.push('send test packet');
			testActionsList.push('send wrong packet');
			testActionsList.push('send join packet');
			*/
			for (var i:uint in TestAction.actionLabels) {
				testActionsList.push(TestAction.actionLabels[i]);
			}
		}
		
		private function el_testActionSelected(actionId:uint):void {
			LOG(LOGGER.C_V, 'action selected:' + testActionsList[actionId]);
			
			switch(actionId) {
				
				case TestAction.ID_A_CONNECT:
					socket.connect(host, port);
					break;
					
				case TestAction.ID_A_DISCONNECT:
					socket.close();
					break;
					
				case TestAction.ID_A_SEND_TEST_PACKET:
					net_sendTestPacket();
					break;
					
				case TestAction.ID_A_SEND_WRONG_TEST_PACKET:
					net_sendWrongTestPacket();
					break;
					
				case TestAction.ID_A_SEND_JOIN:
					net_sendMsgJoin();
					break;
					
				case TestAction.ID_A_SEND_LOGIN:
					net_sendMsgLogin();
					break;

				case TestAction.ID_A_SEND_LOGOUT:
					net_sendMsgLogout();
					break;
			
				case TestAction.ID_A_SEND_PLAYER_MOVE:
					net_sendMsgSetMark();
					break;
					
					
			}
		}
		
		private const testActionsList:Array = [];
				

		//} -> END OF control
		
		
		
		//{ -> data
		private function prepareData():void {
			LOG(LOGGER.C_OP, 'prepareData',0);
			
		}
		//} -> END OF data
		
		
		
		//{ -> network
		private function prepareNetwork():void {
			LOG(LOGGER.C_OP, 'prepareNetwork',0);
			
			try {
				socket= new Socket();
				socket.addEventListener(Event.CONNECT, onSocketConnect);
				socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);	
			} catch (e:Error) {
				LOG(LOGGER.C_NET, 'socket error:' + e.name+'/' + e.message);
			}
		}

		private var host:String = "127.0.0.1";
		private var port:int = 8003;
		private var socket:Socket;
		private var playerId:String = null;
		private var nextMarkXCoord:int=0;
		private var Mark1PlayerId:String;
		private var playerName:String="noNAME";
		
		
		private function onSocketConnect(event:Event):void {
			LOG(LOGGER.C_NET, "Connected to server.");
		}
		
		private function onIOError(event:IOErrorEvent):void {
			LOG(LOGGER.C_NET, "IO Error: " + event.text);
		}
		
		private function onSocketData(event:ProgressEvent):void {
			var type:int = socket.readInt();
			var pid;
			
			switch(type) {
				
				case 207://player_join
					playerId = readStringFromSocket(socket);
					LOG(LOGGER.C_OP, 'player_join THIS player id=' + playerId);
					break;
					
				case 203://other player join
					pid = readStringFromSocket(socket);
					LOG(LOGGER.C_OP, 'player JOINED id=' + pid);
					break;
					
				case 204://other player left temp
					pid = readStringFromSocket(socket);
					LOG(LOGGER.C_OP, 'player lost connection, waiting for him. id=' + pid);
					break;
					
				case 208://other player left perm
					pid = readStringFromSocket(socket);
					LOG(LOGGER.C_OP, 'player LEFT id=' + pid);
					break;
					
				case 209://player came back
					pid = readStringFromSocket(socket);
					var pn = readStringFromSocket(socket);
					LOG(LOGGER.C_OP, 'player '+pn+' RESTORED connection, id=' + pid);
					break;
					
				case 201://game started
					var firstPlayerId = readStringFromSocket(socket);
					Mark1PlayerId = readStringFromSocket(socket);
					LOG(LOGGER.C_OP, 'Game STARTED, firstPlayerId=' + firstPlayerId + ' Mark1PlayerId=' + Mark1PlayerId);
					
					if (playerId.indexOf(firstPlayerId) !== -1) {
						LOG(LOGGER.C_OP, '       it is YOUR turn, '+playerName+' make your mark');
					} else {
						LOG(LOGGER.C_OP, "it is player "+firstPlayerId+" turn, wait for him to put a mark");
					}
					break;
				
				case 501://set mark
					pid = readStringFromSocket(socket);
					var pid2 = readStringFromSocket(socket);
					var markX:int = socket.readInt();
					var markY:int = socket.readInt();
					var winnerMarkSN:int = socket.readInt();
					
					var playerString = "your";
					
					if (playerId.indexOf(pid) == -1) {// not you have marked
						playerString = "player " + pid + " put a";
					}	
					
					//LOG(LOGGER.C_OP, playerId+".indexOf("+pid+")=" + playerId.indexOf(pid));
					LOG(LOGGER.C_OP, playerString+' mark:'+markX+'/'+markY+' ;winnerMarkSN='+winnerMarkSN);
					
					const EMPTY_CELL:int = 0;
					if (winnerMarkSN != EMPTY_CELL) {
						var markSN = 2;
						//LOG(LOGGER.C_OP, "winner test: "+playerId+".indexOf("+Mark1PlayerId+")");

						if (playerId.indexOf(Mark1PlayerId) != -1) {
							markSN = 1;
						}
						if (winnerMarkSN === markSN) {
							LOG(LOGGER.C_OP, "GAME OVER, you won");
						} else {
							LOG(LOGGER.C_OP, "GAME OVER, you have lost");	
						}
						break;
					}
					
				//case 502://player turn
					//LOG(LOGGER.C_OP, ' turn msg INC pid='+pid);
					srv_displayTurnText(pid2);
					break;
					
				case 600://TYPE_OUT_GAME_SESSION_DATA
					//id id int(x9)
					pid = readStringFromSocket(socket);
					
					var boardData = [];
					for (var i = 0; i < 9; i++) {
						boardData.push(socket.readInt());
					}
					
					LOG(LOGGER.C_NET, "received session data: GameBoard data=[" + boardData.join(",") + "]");
					if (pid.indexOf("no id") == -1) {
						srv_displayTurnText(pid);
					}
					break;
					
				default:
					LOG(LOGGER.C_NET, "Received from server: " + type);
					break;
			}
			
			if (socket.bytesAvailable > 0) {
				onSocketData(null);
			}
		}
		
		private function srv_displayTurnText(pid:String):void {
			if (playerId.indexOf(pid) == -1) {// not your
				LOG(LOGGER.C_OP, "player "+pid+" turn. wait for him to set a mark");
			} else {
				LOG(LOGGER.C_OP, "      your turn to set a mark");
			}
		}
		
		
		private function net_sendTestPacket():void {
			var id:int = 100;
			socket.writeInt(id);
			
			var type:int = 250;
			socket.writeInt(type);
			
			socket.flush();
		}
		
		private function net_sendWrongTestPacket():void {
			socket.writeInt(1);
			socket.flush();
		}


		
		private function net_sendMsgJoin():void {
			var type:int = 101;
			socket.writeInt(type);
			
			playerName = 'player name 1';
			writeStringToSocket(socket, playerName);
			
			socket.flush();
		}

		
		private function net_sendMsgLogin():void {
			if (!playerId) {
				LOG(LOGGER.C_OP, 'cannot login cuz player id is null. connect join disconnect connect then login');
				return;
			}
			
			var type:int = 100;
			socket.writeInt(type);
			
			writeStringToSocket(socket, playerId);
			writeStringToSocket(socket, playerName);
			
			socket.flush();
		}

		private function net_sendMsgLogout():void {
			var type:int = 103;
			socket.writeInt(type);
			socket.flush();
		}

		private function net_sendMsgSetMark():void {
			var type:int = 102;
			socket.writeInt(type);
			
			socket.writeInt(0);//x
			socket.writeInt(nextMarkXCoord);//y
			
			socket.flush();
			nextMarkXCoord += 1;
		}

		
		
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

		
		//} -> END OF network
		
		
		
		//{ -> console
		private function prepareConsole(appW:uint, appH:uint, consoleH:uint=400, consoleAlpha:Number=1, consoleBGAlpha:Number=.65):void {
			var cc:ConsoleConfig=new ConsoleConfig;
			cc.alwaysOnTop=false;
			cc.style.traceFontSize=18;
			cc.style.menuFontSize=18;
			cc.style.backgroundAlpha=consoleBGAlpha;
			c = new Console('`', cc);
			addChild(c);
			c.height=consoleH;c.width=appW;
			c.y=appH-consoleH;
			c.alpha=consoleAlpha;
		}
		public static var c:Console;
		//} -> END OF console
		
		
		//{ -> Logging
		private function prepareLogging():void {
			LOGGER.setL(logMessage);
			LOG_CL.push(
				new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_R], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_DT], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_DS], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_V], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_OP], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_NET], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_A], c)
			);
			
		}
		/**
		 * 
		 * @param	c channel id
		 * @param	a message
		 * @param	b level
		 */
		private function logMessage(c:uint, a:String, b:uint=0):void {
			var cc:ConsoleChannel=LOG_CL[c];
			if (!cc) {cc=LOG_CL[0];}
			
			switch (b) {
				
				case LOGGER.LEVEL_ERROR:
					cc.error(a);
					break;
					
				case LOGGER.LEVEL_WARNING:
					cc.warn(a);
					break;
					
				default:
				case LOGGER.LEVEL_INFO:
					cc.log(a);
					break;
					
			}
			
		}
		private static const LOG_CL:Vector.<ConsoleChannel>=new Vector.<ConsoleChannel>;
		//} -> END OF Logging
		
	}
}

class TestAction {

	public static const ID_A_CONNECT:uint = 0; 
	public static const ID_A_DISCONNECT:uint = 1; 
	public static const ID_A_SEND_TEST_PACKET:uint = 2; 
	public static const ID_A_SEND_WRONG_TEST_PACKET:uint = 3; 
	public static const ID_A_SEND_JOIN:uint = 4; 
	public static const ID_A_SEND_LOGIN:uint = 5; 
	public static const ID_A_SEND_LOGOUT:uint = 6; 
	public static const ID_A_SEND_PLAYER_MOVE:uint = 7; 
	
	public function TestAction(id:uint) {
		this.id = id;
	}
	
	public static const actionLabels:Array = [
		"CONNECT" 
		,"DISCONNECT" 
		,"SEND_TEST_PACKET" 
		,"SEND_WRONG_TEST_PACKET"
		,"SEND_JOIN"
		,"SEND_LOGIN"
		,"SEND_LOGOUT"
		,"SEND_PLAYER_MOVE"
	];
	
	public var id:uint;
}


//{ -> History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} -> END OF History

// template last modified:11.03.2011_[18#55#10]_[5]