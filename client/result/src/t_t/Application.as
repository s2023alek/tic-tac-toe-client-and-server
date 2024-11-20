// Project TicTacToe
package t_t {
	
	//{ ======= import
	import t_t.c.vcm.VCMChat;
	import t_t.c.vcm.VCMScreen;
	import t_t.main.TicTacToe;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import t_t.c.system.AEStartup;
	import t_t.c.system.APrepareSystem;
	import t_t.d.a.DUApp;
	import t_t.data.ApplicationConstants;
	import t_t.main.TicTacToe;
	import t_t.media.Text;
	import t_t.v.VCScreen;
	import t_t.v.VCScreenMain;
	import com.junkbyte.console.Console;
	import com.junkbyte.console.ConsoleChannel;
	import com.junkbyte.console.ConsoleConfig;
	import flash.display.DisplayObjectContainer;
	import tk.jinanoimateydragoncat.utils.flow.data.JDM;
	
	import t_t.c.ae.AE;
	import t_t.c.ae.AEApp;
	//} ======= END OF import
	
	
	/**
	 * Main Application Class
	 * contains refs to view objects, data storage
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class Application implements IApplication {
		
		//{ ======= CONSTRUCTOR
		function Application (appContainer:DisplayObjectContainer) {
			appInstance = this;
			ac = appContainer as TicTacToe;
		}
		//} ======= END OF CONSTRUCTOR
		
		/**
		 * seconds
		 * @return
		 */
		public function getCurrentTime():int {
			return getTimer()/1000;
		}
		
		
		public function run():void {
			prepareVCMainScreen();
			log(0,'starting Application name:"'+APP_NAME+'"');
			startup();
		}
		
		private function startup():void {
			log(0,APP_NAME);
			var sse:AEStartup = new AEStartup(this);
			sse.setL(log_systemStartupAgentEnv);
			sse.logMessages = true;
			var ssa:APrepareSystem = new APrepareSystem();
			sse.placeAgent(ssa);
			
		}
		private var ac:TicTacToe;
		
		//{ ======= locale
		public function lText():Text {return localeText;}
		
		public function set_localeId(a:uint):void {
			//will be loaded from xml
			localeText=new Text(null);
			APP.setlText(localeText);
		}
		private var localeText:Text;
		//} ======= END OF locale		
		
		//{ ======= Agents
		/**
		 * Main Agent Environment
		 */
		public function get_ae():AEApp {return ae;}
		public function set_ae(a:AEApp):void {
			ae = a;
			ae.set_appRef(this);
			ae.logMessages=ae_logMessages;
			ae.setL(log_agentEnv);
		}
		private var ae:AEApp;
		//} ======= END OF Agents
		
		//{ ======= Data
		public function get_appData():DUApp {return appData;}
		public function set_appData(a:DUApp):void {appData = a;}
		private var appData:DUApp = new DUApp();
		//} ======= END OF Data
		
		
		//{ ======= VC MainScreen
		private function prepareVCMainScreen():void {
			ms = new VCScreen(ac.stage);
		}
		public function get_Screen():VCScreen {return ms;}
		private var ms:VCScreen;
		//} ======= END OF VC MainScreen
		
		//{ ======= logging
		private function log_systemStartupAgentEnv(m:String, l:uint):void {
			logMessage(LOGGER.C_A, "app startup>"+m, l);
		}
		private function log_agentEnv(m:String, l:uint):void {
			logMessage(LOGGER.C_A, m, l);
		}
		
		/**
		 * @param componentID
		 * @param	c channel id
		 * @param	a message
		 * @param	b level
		 */
		public function logMessage(c:uint, a:String, b:uint=0):void {
			ac.logMessage(c, a, b);
		}
		
		
		private var ae_logMessages:Boolean=Boolean(1);
		//} ======= END OF logging
		
		public function getAppLoadedPath():String {
			return ac.loaderInfo.url.substring(0,ac.loaderInfo.url.lastIndexOf('/'));
		}
		
		//} ======= static helpers
		public static function chatMessage(s:String):void {
			var sm:JDM = JDM.getInstance();
			sm.ss(0,s);
			appInstance.get_ae().listen(VCMChat.ID_A_CHAT_MESSAGE, sm);
			sm.freeInstance();
		}
		
		//} ======= END OF static helpers
		
		
		private static var appInstance:Application;
		
		/**
		 * for app's logger
		 */
		private static const APP_NAME:String = "TicTacToe";
		
		
		
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
			LOG(c,"Application>"+m,l);
		}
		
		
	}
}